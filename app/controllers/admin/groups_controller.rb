class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
    
    
  def show
    @group = Group.find(params[:id])
    #@group.owner_id = current_user.id
  end
  
  def post_index
    @group = Group.find(params[:group_id])
    @post = current_user.posts.new
    @posts = @group.posts
    #Postモデルwhereで検索してgroup_idを元にして取り出す

  end
  
  
  private

  #フォームから渡す必要がないためowner_idはparamsに入れる必要がない
  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  
  
  
  
end
