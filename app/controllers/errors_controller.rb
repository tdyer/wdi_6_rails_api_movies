# This controller will handle all Exceptions thrown by Rails.
# It will create a json error message in the HTTP Response.
class ErrorsController < ApplicationController
  # Create actions/methods for all the HTTP status codes returned from Rails.
  # Each action MUST have a route define in routes.rb, e.g.
  # match "/404", :to => "errors#not_found", via: [:get]
  ActionDispatch::ExceptionWrapper.rescue_responses
    .values.uniq.each do |error_action|
    # define the following actions/methods
    # not_found, method_not_allowed, not_implemented, not_acceptable,
    # unprocessable_entity, bad_request, conflict
    define_method(error_action.to_s) do
      generic_exception(error_action)
    end
  end

  private

  # called from all of above generated actions
  def generic_exception(error_symbol)
    http_status = Rack::Utils.status_code(error_symbol)
    error_info = init_error_info(error_symbol, http_status)

    # Exception that caused error was set in the ShowExceptions middleware
    exception = env["action_dispatch.exception"]
    error_detail(error_info, exception) if exception

    # Also set in the ShowExceptions middleware
    original_path = env["action_dispatch.original_path"]
    original_path && error_info[:originalPath] = original_path

    render json: error_info.to_json,
           status: http_status
  end

  def init_error_info(error_symbol, http_status)
    {
      # TODO: Add specific info for user to submit to support
      userMessage: "Ask for help at help@example.com",
      # Very loose approximation of JSON error draft standard
      # http://tools.ietf.org/html/draft-nottingham-http-problem-01
      # http://phlyrestfully.readthedocs.org/en/latest/problems.html
      describedBy: "http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html",
      # TODO: Provide a URL that will provide detailed text for each error.
      httpStatus: http_status,
      title: Rack::Utils::HTTP_STATUS_CODES[http_status],
      railsErrorSymbol: error_symbol
    }
  end

  def error_detail(info, exception)
    if exception.respond_to?(:detail_message)
      info[:detail] = exception.detail_message
    else
      info[:detail] = "#{exception.class.name} : #{exception.message}"
    end
  end
end
