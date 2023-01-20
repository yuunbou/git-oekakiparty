class Public::HomesController < ApplicationController

  def top
    @posts = Post.where(post_type: 0).published.order('id DESC').limit(4)
  end

  def about
  end

end
