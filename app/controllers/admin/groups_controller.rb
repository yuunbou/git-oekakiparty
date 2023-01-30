class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
    
    
  def show
    @group = Group.find(params[:id])
    #@group.owner_id = current_user.id
  end
  
  def post_index
    @group = Group.find(params[:group_id])
    @posts = @group.posts
  end
  
  def all_destroy
    @group = Group.find(params[:group_id])
    if @group.destroy
      redirect_to groups_admin_user_path(user.id)
    end
  end
  
  
  
  private

  #フォームから渡す必要がないためowner_idはparamsに入れる必要がない
  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  
  
  
  
end
