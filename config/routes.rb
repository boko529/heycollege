Rails.application.routes.draw do
  get 'news/show'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update]
  namespace :admin do
    resources :users, only: [:index]
    resources :news, except: [:index, :show]
  end
  root 'static_pages#home'
  resources :lectures do
    resources :reviews, only: [:create, :show, :destroy] do
      resources :helpfuls, only: [:create]
    end
  end
  resources :teachers, only: [:index, :show]
  resources :notifications, only: :index
  # お知らせのshowページはログイン関係なく見れるので管理者と分けています。
  resources :news, only: [:show]
  resources :groups
end
