class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    comment = current_user.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
     redirect_to post_path(post)
    else
      @post = Post.find(params[:post_id])
      @comment = Comment.new
      @user = @post.user
      flash.now[:alert] = "コメントは１０００文字以下で必須入力です"
      render 'public/posts/show'
    end
  end

  def destroy
    current_user.comments.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
