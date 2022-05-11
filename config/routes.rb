Rails.application.routes.draw do
  resources :likedcomments
  resources :likedsubmissions
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
    
    #Rutas de la api
    #recurs submissions
    get '/api/submissions', to: 'submissions#indexAPI', as: 'indexAPI'
    post '/api/submissions', to: 'submissions#createAPI', as: 'createAPI'
    get '/api/submissions/:submission_id', to: 'submissions#submission_JSON', as: 'submission_JSON'
    get '/api/submissions/:submission_id/comments', to: 'submissions#sub_comments_JSON', as: 'sub_comments_JSON'
    post '/api/submissions/:submission_id/comment', to: 'submissions#commentAPI', as: 'commentAPI'
    post '/api/submissions/:submission_id/vote', to: "submissions#APIVote"
    delete '/api/submissions/:submission_id/vote', to: "submissions#APIUnvote"
    get '/api/submissions/user/:user_id', to: 'submissions#submFromUserJSON', as: 'subm_user_JSON'    
    get '/api/submissions/upvoted/user/:user_id', to: 'submissions#userUpvotesJSON', as: 'user_submissions_upvotes_json'
    
    #recurs comments
    get '/api/comments/:comment_id', to: 'comments#APIcomment_JSON'
    get '/api/comments/liked/user/:user_id', to: 'comments#userlikedJSON', as: 'user_comments_liked_json'
    get '/api/comments/user/:user_id', to: 'comments#user_comments_JSON', as: 'user_comments_JSON'    
    post '/api/comments/:comment_id/vote', to: "comments#APIvote_comment"
    post '/api/comments/comment/:comment_id', to: 'comments#commentJSON'
    post '/api/comments/:comment_id', to: 'comments#APIcomment'
    delete '/api/comments/:comment_id/vote', to: "comments#APIunvote_comment"
    
    #recurs user
    get '/api/users/:user_id', to: 'users#userJSON', as: 'user_JSON'
    put '/api/users/:user_id', to: 'users#updateAPI', as: 'updateAPI'
     
    #Google login
    get '/auth/:provider/callback' => 'sessions#omniauth'

  resources :comments do
      put 'like', on: :member
      put 'unvote', on: :member
  end

  resources :submissions do
      put 'vote', on: :member
      put 'unvote', on: :member
      put 'unvote', on: :member
  end


  resources :users
  root 'submissions#index'
  
end

