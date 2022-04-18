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
    get '/comments/user/:user_id', to: 'comments#commFromUser', as: 'comm_user'
    get '/submissions/upvoted/:user_id', to: 'submissions#userUpvoted', as: 'subm_upv_user'
     get '/comments/upvoted/:user_id', to: 'comments#userUpvoted', as: 'comm_upv_user'
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