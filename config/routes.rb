Rails.application.routes.draw do
  root 'movies#index'

  resources :movies, except: [:new, :edit, :destroy]

  namespace :admin do
    resources :movies
  end

  # Generate routes for each HTTP Error
  # GET    /404(.:format)                   errors#not_found
  # GET    /405(.:format)                   errors#method_not_allowed
  # GET    /501(.:format)                   errors#not_implemented
  # GET    /406(.:format)                   errors#not_acceptable
  # GET    /422(.:format)                   errors#unprocessable_entity
  # GET    /400(.:format)                   errors#bad_request
  # GET    /409(.:format)                   errors#conflict
  ActionDispatch::ExceptionWrapper.rescue_responses.values.uniq.map do |status_symbol|
    code =  Rack::Utils.status_code(status_symbol)
    match "/#{code}", :to => "errors#" << "#{status_symbol.to_s}", via: [:get]
  end
end
