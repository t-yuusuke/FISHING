class Public::CustomersController < ApplicationController
  # ログインしてない状態でtop,aboutページ以外の画面にアクセスできなくする。
  before_action :authenticate_customer!, except: [:top, :about]
  before_action :correct_user, only: [:edit]
  before_action :ensure_guest_customer, only: [:edit]

  def index
    @customers = Customer.page(params[:page]).per(4)
    @customer = Customer.find(current_customer[:id])
  end

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts.page(params[:page]).per(4)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:info] = "編集しました。"
      redirect_to customer_path(@customer.id)
    else
      flash[:denger] = "投稿できません。"
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
  # ゲストユーザーの編集画面に遷移しないように
  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.last_name == "guestuser"
      redirect_to customer_path(current_customer) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
