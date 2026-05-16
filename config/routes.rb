Rails.application.routes.draw do
  # Главная страница теперь рабочая область
  root 'work#index'
  
  # Старые страницы
  get 'main/index'
  get 'main/help'
  get 'main/contacts'
  get 'main/about'
  
  # Маршруты для админки (темы и изображения)
  resources :themes
  resources :images
  resources :values
  resources :users
  
  # Рабочая область 
  match '/work', to: 'work#index', via: :get
  match '/choose_theme', to: 'work#choose_theme', via: :get
  match '/display_theme', to: 'work#display_theme', via: :post
  match '/rate_image', to: 'work#rate_image', via: :post
  match '/next_image', to: 'work#next_image', via: :post
  match '/prev_image', to: 'work#prev_image', via: :post
end
