class Admin::PostsController < ApplicationController

  def index
    @posts = Post.page(params[:page]).per(8)
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path
  end

  private
  # ストロングパラメータ
  def post_params
    params.require(:post).permit(:title, :body, images: [])
  end
end
