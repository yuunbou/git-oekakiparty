class Public::UsersController < ApplicationController
  before_action :correct_user, only:[:edit, :update]

  def show
    @user = User.find(params[:id])
    @user = current_user
    @posts = @user.posts
    if @user.me?(current_user)
      # login user == current_user
      @posts = Post.post_public
      @posts = Post.published
      @posts += @user.posts.unpublished
    else
      @posts = Post.published
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render "edit"
    else
      redirect_to posts_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end

  def favorite
  end

  def index
    @user = current_user
    @users = User.all
    @posts = @user.posts
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) unless @user == current_user
  end

end
