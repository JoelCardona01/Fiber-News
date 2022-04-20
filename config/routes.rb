Rails.application.routes.draw do
  resources :likedcomments
  resources :likedsubmissions
    get '/submissions/newest', to: 'submissions#newest', as: 'newest_submissions'
    get '/submissions/ask', to: 'submissions#ask', as: 'ask_submissions'
    post '/submissions/comment', to: 'submissions#comment', as: 'submissions_comment'
    get '/sessions/logout', to: 'sessions#logout', as: 'logout_sessions'
    get '/comments/tree/:id', to: 'comments#tree', as: 'comments_tree'
    post '/comments/tree/comment', to: 'comments#treecomment', as: 'comments_treecomment'
    post 'comments/comment', to: 'comments#comment', as: 'comments_comment'
    get '/submissions/user/:user_id', to: 'submissions#submFromUser', as: 'subm_user'
    get '/comments/user/:user_id', to: 'comments#commFromUser', as: 'comm_user'
    get '/submissions/upvoted/:user_id', to: 'submissions#userUpvotes', as: 'user_submissions_upvotes'
    get '/comments/upvoted/:user_id', to: 'comments#userUpvotes', as: 'user_comments_upvotes'
    get '/submissions/url/*url', to: 'submissions#submFromUrl', as: 'subm_host'
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
  
  # Routes for Google authentication
    get ‘auth/:provider/callback’, to: ‘sessions#googleAuth’
    get ‘auth/failure’, to: redirect(‘/’)
end

