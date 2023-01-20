class Admin::UsersController < ApplicationController
  #before_action :authentivate_admin!
  
  def index
    @users = User.all  
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
  
  private
  
  def user_params
    params.require(:user).permit(:nickname, :email)
  end
  
  
  
end
