require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'sinatra/json'

require './models'

use Rack::Session::Cookie

get '/' do
  @reviews = Review.all
  p @reviews
  erb :index
end

# user management
helpers do
  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end
end

get '/sign_in' do
  erb :sign_in
end

get '/sign_up' do
  erb :sign_up
end

get '/sign_out' do
  session[:user_id] = nil
  redirect '/'
end

post '/user/create' do
  User.create(
    name: params[:name],
    password: params[:password],
    password_confirmation: params[:password_confirmation]
  )
  redirect "/"
end

post '/session/create' do
  user = User.find_by_name params[:name]
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
  end
  redirect "/"
end

# review
post '/review/create' do
  review = Review.new(title: params[:title], caption: params[:caption], body: params[:body])
  if review.save
    redirect '/'
  else
    @error = "作成できませんでした。"
    @reviews = Review.all
    erb :index
  end
end

get '/review/:id' do
  @review = Review.find(params[:id])
  erb :review
end
