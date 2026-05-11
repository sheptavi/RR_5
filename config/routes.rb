Rails.application.routes.draw do
  get 'values/index'
  get 'values/show'
  get 'values/new'
  get 'values/edit'
  get 'values/create'
  get 'values/update'
  get 'values/destroy'
  get 'images/index'
  get 'images/show'
  get 'images/new'
  get 'images/edit'
  get 'images/create'
  get 'images/update'
  get 'images/destroy'
  get 'themes/index'
  get 'themes/show'
  get 'themes/new'
  get 'themes/edit'
  get 'themes/create'
  get 'themes/update'
  get 'themes/destroy'
  # Главная страница
  root 'main#index'
  
  # Страницы контроллера main
  get 'main/index'
  get 'main/help'
  get 'main/contacts'
  get 'main/about'
  
  # Ресурсы для работы с базой данных
  resources :themes
  resources :images
  resources :values
  resources :users
end
