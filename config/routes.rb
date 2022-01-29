Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :groups, only: [:new, :create, :show, :edit, :update ]
  resources :posts
end