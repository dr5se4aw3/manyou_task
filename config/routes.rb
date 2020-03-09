Rails.application.routes.draw do
  #タスク管理のルーティング
  root 'tasks#index'
  resources :tasks
  #ユーザー管理のルーティング
  resources :users
  #セッション管理のルーティング
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
