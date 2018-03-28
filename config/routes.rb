Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :arenas, only: :index do
      post :play, on: :member
    end
    resources :devices, only: [:create, :destroy]
    resources :players, only: :create
    resources :sessions, only: :create do
      delete :destroy, on: :collection
    end
  end

  resources :docs, path: "/api/docs", only: :index
end
