Rails.application.routes.draw do
    get '/submissions/newest', to: 'submissions#newest', as: 'newest_submissions'
  resources :submissions do
      put 'vote', on: :member
  end
  resources :users
  root 'submissions#index'
  
  # Routes for Google authentication
    get ‘auth/:provider/callback’, to: ‘sessions#googleAuth’
    get ‘auth/failure’, to: redirect(‘/’)
end

