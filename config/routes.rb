Rails.application.routes.draw do
  namespace :admin do
    get 'labels/index'
    get 'labels/new'
    get 'labels/edit'
  end
  root "tasks#index"
  resources :tasks
  resources :users, only: %i[ new create show ]
  resources :sessions, only: %i[ new create destroy ]
  namespace :admin do
    resources :users, only: %i[ new create edit update destroy index ]
    resources :labels, only: %i[ new create edit update destroy index ]
  end
end
