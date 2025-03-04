Rails.application.routes.draw do
  get 'shop/index'
  get 'shop/show'
  get 'shop/checkout'
  get 'shop/success'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :users
  root "users#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
 
  # Defines the root path route ("/")
  # root "posts#index"

  resources :products, only: [:index, :show]
  
  resources :shop, only: [:index, :show] do
    member do
      get :checkout
      get :success
    end
  end
end
