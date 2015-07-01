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
  @recommend = Review.offset(rand(Review.count)).first
  ids = Comment.group(:review_id).order('count_id desc').limit(10).count(:id).keys
  @ranking = Review.find(ids).sort_by {|rank| ids.index(rank.id)}
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

get '/review/:id' do
  @review = Review.find(params[:id])
  erb :review
end

post '/review/create' do
  auth = {
    cloud_name: "",
    api_key:    "",
    api_secret: ""
  }
  uploaded = Cloudinary::Uploader.upload(params[:image][:tempfile].path, auth)
  review = Review.new(
    title: params[:title],
    body: params[:body],
    image_url: uploaded['url'],
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

# category
get '/category/:id' do
  @category = Category.find(params[:id])
  @reviews = Review.where(category: @category).all
  @categories = Category.all
  @recommend = Review.offset(rand(Review.count)).first
  ids = Comment.group(:review_id).order('count_id desc').limit(10).count(:id).keys
  @ranking = Review.find(ids).sort_by {|rank| ids.index(rank.id)}
  erb :index
end

# user
get '/user/:id' do

  @user = User.find(params[:id])
  @categories = Category.all
  @reviews = Review.where(user: @user).all
  @recommend = Review.offset(rand(Review.count)).first
  ids = Comment.group(:review_id).order('count_id desc').limit(10).count(:id).keys
  @ranking = Review.find(ids).sort_by {|rank| ids.index(rank.id)}
  erb :index
end

# comment

post '/review/:id/comment' do
  review = Review.find(params[:id])
  if review && current_user
    Comment.create(review: review, user: current_user, text: params[:text])
  end
  redirect "/review/#{params[:id]}"
end
