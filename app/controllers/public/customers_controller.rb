class Public::CustomersController < ApplicationController
  # ログインしてない状態でtop,aboutページ以外の画面にアクセスできなくする。
  before_action :authenticate_customer!, except: [:top, :about]
  before_action :correct_user, only: [:edit]

  def index
    @customers = Customer.all
    @customer = Customer.find(current_customer[:id])
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customer_path(@customer.id)
    else
      render "edit"
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to root_path
  end

  def favorites
    @customer = Customer.find(params[:id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :profile_image)
  end
  # 他人の編集画面に遷移しないようにする
  def correct_user
    @customer = Customer.find(params[:id])
    @post = @customer
    unless @customer == current_customer
      redirect_to customer_path(current_customer)
    end
  end
end
