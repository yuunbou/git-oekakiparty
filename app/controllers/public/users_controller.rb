class Public::UsersController < ApplicationController
  before_action :correct_user, only:[:edit, :update]

  def show
    @user = User.find(params[:id])
    if @user.me?(current_user.id)
      #今ログインしているのが自分か確認

      @posts = @user.posts.where(post_type: 0)
      #whereを使ってpost_typeを検索して投稿した自分だったら全てを表示する
    else
     #公開中のもののみ他人に表示される 非公開は他人に表示されない
      @posts = @user.posts.where(post_type: 0).published
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
