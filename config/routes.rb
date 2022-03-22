Rails.application.routes.draw do
  resources :submissions
  resources :users
  root 'submissions#index'
end