Rails.application.routes.draw do
  root 'movies#index'

  resources :movies, except: [:new, :edit, :destroy]

  namespace :admin do
    resources :movies
  end

  # Rails Error Handlers. Will return JSON errors.
  match "/404", :to => "errors#not_found", via: [:get]
  match "/405", :to => "errors#method_not_allowed", via: [:get]
  match "/501", :to => "errors#not_implemented", via: [:get]
  match "/406", :to => "errors#not_acceptable", via: [:get]
  match "/422", :to => "errors#unprocessable_entity", via: [:get]
  match "/400", :to => "errors#bad_request", via: [:get]
  match "/409", :to => "errors#conflict", via: [:get]

  # TODO: Generate the above error handler routes from:
  #   ActionDispatch::ExceptionWrapper.rescue_responses.values.uniq.map do |status_symbol|
  #     code =  Rack::Utils.status_code(status_symbol)
  #     msg = Rack::Utils::HTTP_STATUS_CODES[code]
  #     [status_symbol, code, msg]
  #  end
  # [[:not_found, 404, "Not Found"],
  # ...
  #  [:conflict, 409, "Conflict"]]


end
