Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :arenas, only: :index do
      post :leave, on: :member
      post :play, on: :member
      get :score, on: :member
    end
    resources :devices, only: [:create, :destroy]
    resources :matches, only: :create do
      post :capture, on: :member
    end
    resources :players, only: [:create, :show]
    resources :sessions, only: :create do
      delete :destroy, on: :collection
    end
  end

  resources :docs, path: "/api/docs", only: :index
end
