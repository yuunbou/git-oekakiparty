class Public::PostsController < ApplicationController
  #before_action :correct_user, only:[:edit, :update]
  
  def new
      @post = Post.new
  end
  
  def create
    @post = Post.new(post_params)
    @post.type = "public"
    #投稿のタイプ（個人投稿）
    @post.user_id = current_user.id
    if @post.save!
      redirect_to post_path(@post.id)
    else
        render :new
    end
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    post = Post.find(params[:id])
    post.type = 'public'
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
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :caption, :image, :is_status, :type)
  end
  
  
end
