Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :players, only: :create
  end
end
