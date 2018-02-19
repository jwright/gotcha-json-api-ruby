Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :arenas, only: :index do
      post :play, on: :member
    end
    resources :players, only: :create
  end
end
