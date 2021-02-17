Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users 
  namespace :admin do
  resources :users, only: [:index]
  end
  root 'static_pages#home'
  resources :lectures
end
