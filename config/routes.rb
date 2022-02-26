Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'
  resources :groups, only: [:new, :create, :show, :edit, :update ]
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  resources :group_posts, only: [:create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
  get 'group_posts/new/:id', to: 'group_posts#new', as: :new_group_post
end