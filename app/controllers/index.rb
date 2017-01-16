get '/' do
  erb :index
end

#manda a la vista con los tweets
get '/:username' do 
  @user = validate_user(params[:username])
  @tweets = actualize_tweet_cache
  @tweets
  erb :show_tweets
end


#Toma el twitter handles del usuario
post '/user' do
  user = params[:username]
  redirect to "/#{user}"
end


#Metodo que valida que el usuario no exista previamente en la base de datos
def validate_user(user)
  valid_user = TwitterUser.find_by(twitter_handles: user)
  if valid_user == nil 
    valid_user = TwitterUser.create(twitter_handles: user)
  end  
  valid_user
end  

#Metodo que actualiza la base de datos cache
def actualize_tweet_cache
 #Se detecta cuando fue la ultima actualizacion 
 last_db_entry = Time.now.utc - @user.tweets.order(:created_at).last.created_at
  #si no hay tweets o la ultima actualizacion fue hace tiempo, se crean nuevos tweets
  if @user.tweets.length == 0 || last_db_entry > 2000
    tweets = CLIENT.user_timeline(@user, count: 10)
    tweets.each do |tweet|
      Tweet.create(twitter_user_id: @user.id, body: tweet.text, user_creation_time: tweet.created_at )
    end
    return tweets
  #Si existen tweets solo se ponen en un arreglo todos los tweets
  else 
    tweets = Tweet.where(twitter_user_id: @user.id)
  end 
end  



