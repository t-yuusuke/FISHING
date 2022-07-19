class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :correct_user, only: [:edit]

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
    @customer = Customer.find(current_customer[:id])
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @customer = Customer.find(current_customer[:id])
    @customer = @post.customer
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      flash[:success] = "投稿しました。"
      redirect_to post_path(@post.id)
    else
      render "new"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :body, images: [])
  end

  def correct_user
    @post = Post.find(params[:id])
    @customer = @post.customer
    redirect_to customer_path(current_customer) unless @customer == current_customer
  end
end
