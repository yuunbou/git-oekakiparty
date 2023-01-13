class Public::GroupPostsController < ApplicationController

# 使用しないため削除方法を調べる
  def index
    @post = current_user.posts.new
  end

  def create
    @post = Post.new(post_params)
    @post.post_type = 'private'
    @post.save!
  end

  def show
  end

  def edit
  end

  def update
  end

  private



end
