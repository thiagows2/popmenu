Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :restaurants, only: %i[index show] do
    member do
      get :menus
      get :menu_items
    end
  end

  resources :menu_items, only: %i[index]
  resources :menus, only: %i[index]

  namespace :imports do
    resources :restaurants, only: :create
  end
end
