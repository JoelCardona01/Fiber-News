Rails.application.routes.draw do
    get '/submissions/newest', to: 'submissions#newest', as: 'newest_submissions'
    get '/submissions/ask', to: 'submissions#ask', as: 'ask_submissions'
    
    get '/sessions/logout', to: 'sessions#logout', as: 'logout_sessions'
    
    #Google login
    get '/auth/:provider/callback' => 'sessions#omniauth'

  resources :submissions do
      put 'vote', on: :member
  end
  resources :users
  root 'submissions#index'
end