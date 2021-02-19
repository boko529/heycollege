Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update]
  namespace :admin do
    resources :users, only: [:index]
  end
  root 'static_pages#home'
  resources :lectures do
    resources :reviews, only: [:create, :show, :destroy] do
      resources :helpfuls, only: [:create]
    end
  end
  resources :teachers
  resources :notifications, only: :index
end
