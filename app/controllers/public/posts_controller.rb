class Public::PostsController < ApplicationController
  before_action :correct_user, only:[:edit, :update]

  def new
      @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    #投稿のタイプ（個人投稿）
    @post.user_id = current_user.id
    @post.post_type = "post_public"
    if @post.save!
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
    if @post.user == current_user
      render "show"
    else
      redirect_to posts_path
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.type = 'post_public'
    if post.update(post_params)
        redirect_to post_path(@post.id)
    else
        render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def index
    @user = current_user
    @posts = Post.published
    #下記、投稿したユーザーは非公開でも表示される設定
    #if @user.me?(current_user)
      # login user == current_user
      #@posts = Post.post_public
      #@posts = Post.published
      #@posts += @user.posts.unpublished
    #else
      #@posts = Post.published
    #end
  end

  private

  def post_params
    params.require(:post).permit(:title, :caption, :is_status, :post_type, images: []).merge(user_id: current_user.id)
  end

  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    redirect_to(posts_path) unless @user == current_user
  end


end
