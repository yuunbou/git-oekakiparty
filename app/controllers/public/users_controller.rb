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

      @posts = @user.posts.where(post_type: 0).order('id DESC').limit(5)
      #whereを使ってpost_typeを検索して投稿した自分だったら全てを表示する
    else
     #公開中のもののみ他人に表示される 非公開は他人に表示されない
      @posts = @user.posts.where(post_type: 0).published.order('id DESC').limit(5)

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
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  #ユーザーの投稿一覧
  def posts
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).pluck(:post_id)
    #pluck = 指定したカラム(この場合post_id)のレコードの配列を取得
    if @user.me?(current_user.id)
      #今ログインしているのが自分か確認

      @posts = @user.posts.where(post_type: 0).order('id DESC').limit(5)
      #whereを使ってpost_typeを検索して投稿した自分だったら全てを表示する
    else
     #公開中のもののみ他人に表示される 非公開は他人に表示されない
      @posts = @user.posts.where(post_type: 0).published.order('id DESC').limit(5)

    end
  end

  def index
    if params[:search].present? && params[:word].present?
      @users = User.search(params[:search], params[:word])
    else
      @users = User.all
    end
  end

  #グループにユーザーを追加する為のリスト
  def user_list
    @user = User.all
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
