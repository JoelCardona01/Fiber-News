Rails.application.config.middleware.use OmniAuth::Builder do

  provider :google_oauth2, '857539539159-1b5d1651r0jgdbke8oi2nd4q98v01089.apps.googleusercontent.com','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', skip_jwt: true

end