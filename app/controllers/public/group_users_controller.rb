class Public::GroupUsersController < ApplicationController
  
  def create
    user = User.find(params[:user_id])
    group_user = current_user.group_user.new(user_id: user.id)
    group_user.save
    redirect_to edit_group_path(group)
  end
  
 private
 
 def group_user_params
   params.require(:group_user).permit(:user_id)
 end
  
  
end
