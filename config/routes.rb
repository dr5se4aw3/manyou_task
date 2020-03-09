Rails.application.routes.draw do
  #タスク管理のルーティング
  root 'tasks#index'
  resources :tasks
  #ユーザー管理のルーティング
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
