Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'static_pages#home'
  resources :lectures do
    resources :reviews, only: [:create, :show, :destroy] do
    # レビューの編集を有りにする場合
    # resources :reviews, only: [:create, :show, :destroy, :edit, :update]
      resources :helpfuls, only: [:create, :destroy]
    end
  end
end
