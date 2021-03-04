Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :confirmation => 'devises/confirmations',
    :registrations => 'devises/registrations',
    :sessions => 'devises/sessions',
    :passwords => 'devises/passwords'
  }
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
  # herokuに既存のユーザーにinitポイントを付与、一度限りのやつです
  get 'admin/user/set_init_point', to: 'admin/users#set_init_point'

end
