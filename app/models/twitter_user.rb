class TwitterUser < ActiveRecord::Base
   has_many :tweets
   validates :twitter_handles, uniqueness: true



   
end
