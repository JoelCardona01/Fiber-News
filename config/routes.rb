Rails.application.routes.draw do
  resources :likedcomments
  resources :likedsubmissions
    get '/submissions/newest', to: 'submissions#newest', as: 'newest_submissions'
    get '/submissions/ask', to: 'submissions#ask', as: 'ask_submissions'
    post '/submissions/comment', to: 'submissions#comment', as: 'submissions_comment'
    get '/sessions/logout', to: 'sessions#logout', as: 'logout_sessions'
    get '/comments/:id/tree', to: 'comments#tree', as: 'comments_tree'
    post 'comments/comment', to: 'comments#comment', as: 'comments_comment'
    get '/submissions/user/:user_id', to: 'submissions#submFromUser', as: 'subm_user'
    #Google login
    get '/auth/:provider/callback' => 'sessions#omniauth'

  resources :comments do
      put 'like', on: :member
      put 'unvote', on: :member
  end

  resources :submissions do
      put 'vote', on: :member
      put 'unvote', on: :member
  end

  resources :users
  root 'submissions#index'
end