class TwitterUser < ActiveRecord::Base
   has_many :tweets
   validates :twitter_handles, uniqueness: true

#Metodo que valida que el usuario no exista previamente en la base de datos
def validate_user(user)
  valid_user = TwitterUser.find_by(twitter_handles: user)
  if valid_user == nil 
    valid_user = TwitterUser.create(twitter_handles: user)
  end  
  valid_user
end  


   
end
