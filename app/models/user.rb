class User < ApplicationRecord
    has_many :submissions
    has_many :comments
    
    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_initialize do |user|
        user.name = auth.info.name
        user.email = auth.info.email
        user.APIKey = Digest::SHA256.hexdigest user.email.insert(user.email.length/3, user.id.to_s)
      end
    end
  
end
