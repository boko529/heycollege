Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :confirmation => 'devises/confirmations',
    :registrations => 'devises/registrations',
    :sessions => 'devises/sessions',
    :passwords => 'devises/passwords'
  }
  get "users" => redirect("users/sign_up")
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update]
  namespace :admin do
    resources :users, only: [:index]
    resources :news, except: [:index, :show]
  end
  root 'static_pages#home'
  resources :lectures do
    resources :reviews, only: [:create, :destroy] do
      resources :helpfuls, only: [:create]
    end
    resource :bookmarks, only: [:create,:destroy]
  end
  resources :bookmarks, only: [:index]
  resources :teachers, only: [:index, :show]
  resources :notifications, only: :index
  # お知らせのshowページはログイン関係なく見れるので管理者と分けています。
  resources :news, only: [:show]
  resources :groups do
    member do
      get :users
    end
    member do
      resources :group_profiles, only: [:new, :create] # new, createはgroupのidを取得したい.
    end
  end
  resources :group_profiles, only: [:edit, :update, :destroy] # edit, update, destroyはgroupのid必要ない.
  get 'groups/:id/edit_admin', to: 'groups#edit_admin'
  patch 'groups/:id/update_admin', to: 'groups#update_admin'
  resources :users do
    member do
      get :group
    end
  end

  resources :user_group_relations, only: [:create, :destroy, :edit, :update]
  post 'follow/:id', to: 'relationships#follow', as: 'follow'
  post 'unfollow/:id', to: 'relationships#unfollow', as: 'unfollow'
  get 'users/following/:user_id', to: 'users#following', as:'users_following'
  get 'users/follower/:user_id', to: 'users#follower', as:'users_follower'
  # 言語切り替え用rooting
  get "/application/change_language/:language" => "application#change_language"
  patch "/users/:id/hide" => "users#hide", as: 'users_hide' # 退会用
  # redis実験用 すぐ消します
  resource :redis, only: %i[show]
end
