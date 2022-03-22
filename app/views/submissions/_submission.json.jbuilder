json.extract! submission, :id, :url, :title, :created_at, :updated_at
json.url submission_url(submission, format: :json)
