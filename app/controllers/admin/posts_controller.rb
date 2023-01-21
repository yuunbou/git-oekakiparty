class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts
      #.order(created_at: :desc)
      #order＝並び順　:descだったら大きい順　:ascで小さい順
    #＆＆を使うことでxx かつという意味になる
    elsif params[:search].present? && params[:word].present?
      @posts = Post.search(params[:search], params[:word])

    else
      @posts = Post.where(post_type: 0)
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
    
  def destroy
  end
    
end
