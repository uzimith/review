require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'sinatra/json'

require './models'

use Rack::Session::Cookie

get '/' do
  @reviews = Review.all
  @categories = Category.all
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
  review = Review.new(
    title: params[:title],
    caption: params[:caption],
    body: params[:body],
    image: Base64.encode64(params[:image][:tempfile].read),
    image_name: params[:image][:filename],
    image_content_type: params[:image][:type],
    user_id: current_user.id,
    category_id: params[:category_id]
  )

  if review.save
    redirect '/'
  else
    @error = "作成できませんでした。"
    @reviews = Review.all
    erb :index
  end
end

get '/review/:id/image' do
  review = Review.find(@params[:id])
  content_type review.image_content_type
  Base64.decode64(review.image)
end

# category
get '/category/:id' do
  @category = Category.find(params[:id])
  @reviews = Review.where(category: @category).all
  @categories = Category.all
  erb :index
end

# user
get '/user/:id' do
  @user = User.find(params[:id])
  @categories = Category.all
  @reviews = Review.where(user: @user).all
  erb :index
end
