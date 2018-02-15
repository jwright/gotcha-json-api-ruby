Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :arenas, only: :index
    resources :players, only: :create
  end
end
