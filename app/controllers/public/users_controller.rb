class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]
  before_action :set_user, only: [:favorites]

  def show
    @user = User.find(params[:id])
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
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

  def favorites
    @user = User.find(params[:id])
    favorites= Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  def index
    @users = current_user
    @users = User.all
    #公開中のもののみ他人に表示される 非公開は他人に表示されない
    @posts = Post.where(post_type: 0).published
    #@posts = @user.posts.where(post_type: 0).published
    #ユーザー一覧のpost一覧は個人投稿のみ
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) unless @user == current_user
  end

  #favorites用
  def set_user
    @user = User.find(params[:id])
  end

end
