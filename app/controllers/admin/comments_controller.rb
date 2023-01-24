class Admin::CommentsController < ApplicationController
    def index
        @comments = Comment.page(params[:page])
    end
    
    def destroy
        Comment.find(params[:id]).destroy
        redirect_to admin_comments_path(params[:post_id])
    end
    
    private
    
    def comment_params
        params.require(:comment).permit(:comment)
    end
    
    
end
