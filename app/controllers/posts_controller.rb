class PostsController < ApplicationController
  # callback
  #run the authenticate_user for every action except the index action
  before_action :authenticate_user, except: [:index, :show]
  # authenticate user will run for create, update, and destroy
  # authenticate admin will run for update and destroy
  before_action :authorize_post_owner, only: [:update, :destroy]
  #anyone can see the data - index and show
  #only admins can updata or destroy

  def index
    @posts = Post.all.order(:id)

    if params[:tag] && params[:tag] != ""
      tag = Tag.find_by(name: params[:tag])
      @posts = tag.posts
    end
    
    render :index
  end

  def create
    @post = Post.new(
      title: params[:title],
      body: params[:body],
      image: params[:image],
      user_id: current_user.id
    )
    if @post.save
      render :show
    else
      render json: { errors: post.errors.full_messages }, status: :bad_request
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    render :show
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.title = params[:title] || post.title
    @post.body = params[:body] || post.body
    @post.image = params[:image] || post.image
    @post.user_id = params[:user_id] || post.user_id
    if @post.save
      render :show
    else
      render json: { errors: post.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    render json: { message: "Post successfully destroyed!" }
  end
end
