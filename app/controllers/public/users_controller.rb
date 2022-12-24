class Public::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @user = current_customer
  end
  
  def edit
    @user = User.find(params[:id])
    @user = current_customer
  end
  
  def update
  end
  
  def favorite
  end
  
  def index
  end
  
  private
  
  def user_params
    params.require(:user).permit(:nickname)
  end
  
end
