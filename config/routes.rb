Rails.application.routes.draw do
  root 'work#index'
  
  # Маршруты для входа/регистрации
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/signin',  to: 'sessions#new'
  post   '/signin',  to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
  
  get 'main/index'
  get 'main/help'
  get 'main/contacts'
  get 'main/about'
  
  resources :themes
  resources :images
  resources :values
  resources :users, only: [:index, :new, :create, :show]
  
  match '/work', to: 'work#index', via: :get
  match '/choose_theme', to: 'work#choose_theme', via: :get
  match '/display_theme', to: 'work#display_theme', via: :post
  match '/rate_image', to: 'work#rate_image', via: :post
  
  namespace :api do
    post 'next_image', to: 'api#next_image'
    post 'prev_image', to: 'api#prev_image'
  end
end
