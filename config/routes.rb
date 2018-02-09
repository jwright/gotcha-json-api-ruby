Rails.application.routes.draw do
  namespace :api do
    resources :players, only: :create
  end
end
