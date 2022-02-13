Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :groups, only: [:new, :create, :show, :edit, :update ]
  resources :posts
  resources :group_posts, only: [:create, :show, :edit, :update, :destroy]
  get 'group_posts/new/:id', to: 'group_posts#new', as: :new_group_post
end