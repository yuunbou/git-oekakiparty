class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
    
    
  def show
    @group = Group.find(params[:id])
  end
  
  def post_index
    @group = Group.find(params[:group_id])
    @posts = @group.posts
  end
  
  
  private

  # フォームから渡す必要がないためowner_idはparamsに入れる必要がない
  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  
  
  
  
end
