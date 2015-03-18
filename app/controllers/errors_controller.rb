# This controller will handle all Exceptions thrown by Rails.
# It will create a json error message in the HTTP Response.

class ErrorsController < ApplicationController

  # Create actions for all the HTTP status codes returned from Rails.
  ActionDispatch::ExceptionWrapper.rescue_responses.values.uniq.each do |error_action|
    # :not_found, :method_not_allowed, :not_implemented, :not_acceptable,
    # :unprocessable_entity, :bad_request, :conflict
    define_method(error_action.to_s) do
      generic_exeception(error_action)
    end
  end

  private

  def generic_exeception(error_symbol)
    # 404 = Rack::Utils.status_code(:not_found)
    http_status = Rack::Utils.status_code(error_symbol)

    # Very loose approximation of JSON error draft standard
    # http://tools.ietf.org/html/draft-nottingham-http-problem-01
    # http://phlyrestfully.readthedocs.org/en/latest/problems.html
    error_info = {
      # TODO: Provide a URL that will provide detailed text for each error.
      :describedBy => "http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html",
      :httpStatus => http_status,
      :title => Rack::Utils::HTTP_STATUS_CODES[http_status],
      :railsErrorSymbol => error_symbol
    }

    # TODO: Add specific info for user to submit to support
    error_info[:userMessage] = "Yell for help at help@example.com"

    # Exception that caused error was set in the ShowExceptions middleware
    if exception = env["action_dispatch.exception"]
      if exception.respond_to?(:detail_message)
        error_info[:detail] = exception.detail_message
      else
        error_info[:detail] = "#{exception.class.name} : #{exception.message}"
      end
    end

    # Also set in the ShowExceptions middleware
    if original_path = env["action_dispatch.original_path"]
      error_info[:originalPath] = original_path
    end

    render :json => error_info.to_json, :status => http_status
  end

end
