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
    resource :bookmarks, only: [:create,:destroy]
  end
  resources :bookmarks, only: [:index]
  resources :teachers, only: [:index, :show]
  resources :notifications, only: :index
  # お知らせのshowページはログイン関係なく見れるので管理者と分けています。
  resources :news, only: [:show]
  post 'follow/:id', to: 'relationships#follow', as: 'follow'
  post 'unfollow/:id', to: 'relationships#unfollow', as: 'unfollow'
  get 'users/following/:user_id', to: 'users#following', as:'users_following'
  get 'users/follower/:user_id', to: 'users#follower', as:'users_follower'
  resources :zooms, only: [:index,:new,:create,:show,:destroy]
  get 'users/:id/zoom_room', to: 'zooms#create', as:'create_zoom'
end