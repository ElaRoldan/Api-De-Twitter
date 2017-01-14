class Tweet < ActiveRecord::Base
  belongs_to :twitter_user

  #Metodo que guarda los tweets en el cache
  def create_tweet_cache(tweets)
     tweets.each do |tweet|
      Tweet.create(twitter_user_id: @user.id , body: tweet.text)
    end  
  end  

end
