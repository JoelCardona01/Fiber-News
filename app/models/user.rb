class User < ApplicationRecord
    
    def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.name = auth.info.first_name
      user.email = auth.info.email
    end
  end
  
end
