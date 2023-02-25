class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:search].present? && params[:word].present?
      #Userモデルファイルにsearchとwordを定義
      @users = User.search(params[:search], params[:word]).page(params[:page]).per(10)
    else
      @users = User.page(params[:page])
    end
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(post_type: 0).recent
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to admin_user_path(user.id)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
  
  def posts
    @user = User.find(params[:id])
    # pluck = 指定したカラム(この場合post_id)のレコードの配列を取得
    @posts = Post.where(user_id: @user.id).pluck(:id)
    # whereを使ってpost_typeを検索して投稿した自分だったら全てを表示する
    @posts = @user.posts.where(post_type: 0).page(params[:page])
  end
  
  def groups
    @user = User.find(params[:id])
    # @groups= GroupUser.where(user_id: @user.id).page(params[:page]).pluck(:group_id)
    # アソシエーションでgroupは持っているためwhereを使わずとも下記の定義でとってこれる
    @groups = @user.groups.page(params[:page])
  end
  
  def group_post
    @user = User.find(params[:id])
    @posts = @user.posts.where(post_type: 1).order('id DESC').page(params[:page])
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nickname, :email, :is_active)
  end
  
  
  
end
