class TweetsController < ApplicationController

  get '/tweets' do
    if Helpers.is_logged_in?(session)
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :'tweets/new'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
    else
      redirect to '/login'
    end
    erb :'tweets/show_tweet'
  end

  post '/tweets' do
    @user = User.find_by(session[:user_id])
    if (params.has_value?(""))
      redirect to '/tweets/new'
    elsif !params.empty?
      @tweet = Tweet.new(content: params["content"])
      @tweet.user_id = @user.id
      @tweet.save
      @user.tweets << @tweet
      @user.save
    end
    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session)
        @tweet.destroy
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end

      redirect to '/login'
  end

  get '/tweets/:id/edit' do
      if Helpers.is_logged_in?(session)
        @tweet = Tweet.find_by_id(params[:id])
      else
        redirect to '/login'
      end
    erb :'tweets/edit_tweet'
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if Helpers.is_logged_in?(session) && !params["content"].empty?
        @tweet.update(content: params[:content])
        @tweet.save
      else
        redirect to "/tweets/#{@tweet.id}/edit"
    end
    redirect to "/tweets/#{@tweet.id}"
  end

end
