Rails.application.routes.draw do
  resources :submissions do
      put 'vote', on: :member
  end
  resources :users
  root 'submissions#index'
end