Rails.application.routes.draw do
    get '/submissions/newest', to: 'submissions#newest', as: 'newest_submissions'
  resources :submissions do
      put 'vote', on: :member
  end
  resources :users
  root 'submissions#index'
end