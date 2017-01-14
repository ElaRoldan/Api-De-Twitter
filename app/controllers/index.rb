get '/' do
  erb :index
end

#Toma el twitter handles del usuario
post '/user' do
  user = params[:username]
  redirect to "/#{user}"
end

get '/:username' do 
  @user = validate_user(params[:username])
  @tweets = CLIENT.user_timeline(@user, count: 2)
   actualize_tweet_cache(@tweets)

  erb :show_tweets
end

def validate_user(user)
  valid_user = TwitterUser.find_by(twitter_handles: user)
  if valid_user == nil 
    valid_user = TwitterUser.create(twitter_handles: user)
  end  
  valid_user
end  

#Metodo que actualiza la base de datos cache
def actualize_tweet_cache(tweets)
  databse_tweets = Tweet.where(twitter_user_id: @user.id)
  p databse_tweets.count
  new_tweets = []
  #Se detectan los nuevos tweets
  if databse_tweets.count > 0
    tweets.each do |tweet|
      databse_tweets.each do |database_tweet|
        if tweet.created_at != database_tweet.user_creation_time
          p tweet.id 
          p "tweet del timeline #{tweet.created_at}"
          p "fecha de la base de datos #{database_tweet.user_creation_time}"
          p tweet.text
          new_tweets << tweet
        end  
      end  
    end 
  else 
    tweets.each do |tweet|
      p tweet.created_at
      Tweet.create(twitter_user_id: @user.id, body: tweet.text, user_creation_time: tweet.created_at)
    end
  end  
  #Se guardan los nuevos tweets en la base de datos 
  # p "=" * 50
  # p new_tweets
  # if new_tweets
  #   new_tweets.each do |new_tweet|
  #     p new_tweet.text
  #     Tweet.create(twitter_user_id: @user.id, body: new_tweet.text, user_creation_time: new_tweet.created_at)        
  #   end
  # end   




end  



