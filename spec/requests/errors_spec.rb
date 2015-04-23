require 'rails_helper'

describe 'Errors' do
  before do
  end

  it "GET /404" do
    #  curl -i  http://localhost:3000/404
    # {"describedBy":"http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html",
    # "httpStatus":404,"title":"Not Found","railsErrorSymbol":"not_found",
    # "userMessage":"Yell for help at help@example.com"}

    get '/404'
    expect(response.status).to eq 404
    error = JSON.parse(response.body)

    expect(error['httpStatus']).to eq 404
    expect(error['title']).to eq "Not Found"
    expect(error['railsErrorSymbol']).to eq 'not_found'
  end

  # Generate an array of arrays, one for each Rails HTTP status code
  #  [[:not_found, 404, "Not Found"],
  #  [:method_not_allowed, 405, "Method Not Allowed"],
  #  [:not_implemented, 501, "Not Implemented"],
  #  [:not_acceptable, 406, "Not Acceptable"],
  #  [:unprocessable_entity, 422, "Unprocessable Entity"],
  #  [:bad_request, 400, "Bad Request"],
  #  [:conflict, 409, "Conflict"]]
  @rails_status = ActionDispatch::ExceptionWrapper.rescue_responses.values
                  .uniq.map do |status_symbol|
    code =  Rack::Utils.status_code(status_symbol)
    msg = Rack::Utils::HTTP_STATUS_CODES[code]
    [status_symbol, code, msg]
  end

  # Generate examples for each Rails HTTP Status code
  @rails_status.each do |status|
    status_code_symbol, status_code, status_msg = *status

    it "GET /#{status_code}" do
      get "/#{status_code}"
      expect(response.status).to eq status_code
      error = JSON.parse(response.body)

      expect(error['httpStatus']).to eq status_code
      expect(error['title']).to eq status_msg
      expect(error['railsErrorSymbol']).to eq status_code_symbol.to_s
    end
  end
end
