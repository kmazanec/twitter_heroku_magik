get '/' do
  if session[:message]
    @message = session[:message]
  end

  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  Twitter.configure do |config|
    config.consumer_key = ""
    config.consumer_secret = ""
  end

  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token

  @user = User.find_or_create_by(username: @access_token.params[:screen_name],
                                oauth_token: @access_token.token,
                                oauth_secret: @access_token.secret )

  puts "=============================="
  puts @access_token.inspect
  puts @access_token.params[:user_id]
  puts @access_token.params[:screen_name]
  puts "=============================="

  Twitter.configure do |config|
    config.oauth_token = @access_token.token
    config.oauth_token_secret = @access_token.secret
  end

  session[:user_id] = @user.id

  erb :index
  
end


post '/send_tweet' do

  user = User.find(session[:user_id])

  Twitter.configure do |config|
    config.oauth_token = user.oauth_token
    config.oauth_token_secret = user.oauth_secret
  end


  if Twitter.update(params[:new_tweet])
    session[:message] = "Successfully tweeted!"
  else
    session[:message] = "Failed to send message"
  end

  if request.xhr?
    session[:message]
  else
    redirect to '/'
  end
end