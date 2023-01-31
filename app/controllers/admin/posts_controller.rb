class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.page(params[:page])
      #.order(created_at: :desc)
      #order＝並び順　:descだったら大きい順　:ascで小さい順
    #＆＆を使うことでxx かつという意味になる
    elsif params[:search].present? && params[:word].present?
      @posts = Post.search(params[:search], params[:word]).page(params[:page])

    else
      #何も入力せず検索を押した場合
      @posts = Post.where(post_type: 0).page(params[:page])
    end

  end
    
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts
    else
      @posts = Post.where(post_type: 0)
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name)
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(/[[:blank:]]/)
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to admin_post_path(@post.id)
    else
        render :edit
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path
  end
  
  private  
  
  def post_params
    params.require(:post).permit(:group_id, :title, :caption, :is_status, :post_type, images: [])
  end
  
    
end
