class User < ApplicationRecord
    
    def self.update(params)
      user.about = params.about
    end
    
    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_initialize do |user|
        user.name = auth.info.name
        user.email = auth.info.email
      end
    end
  
end
