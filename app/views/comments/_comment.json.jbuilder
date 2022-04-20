json.extract! comment, :id, :text, :postid, :parentid, :likes, :created_at, :updated_at
json.url comment_url(comment, format: :json)
