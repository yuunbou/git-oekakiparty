class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update, :join_group]
  before_action :limit_group, only:[:post_index]
  
  def new
    @group = Group.new
    if current_user.email == "guest@example.com" 
      redirect_to root_path
    end
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    @group.users << current_user
    if @group.save
      redirect_to groups_user_path(current_user), notice: "グループを作成しました"
    else
      render 'new'
    end
  end
  
  def join_group
    @group = Group.find(params[:group_id])
    @user = current_user
    if params[:search].present? && params[:word].present?
      @users = User.search(params[:search], params[:word]).where.not(id: @group.owner_id).where.not(is_active: false).page(params[:page]).per(10)
    else
      @users = User.where.not(id: @group.owner_id).where.not(is_active: false).page(params[:page]).per(10)
    end
  end
  
  def join_user
    @group = Group.find(params[:group_id])
    @group.users << User.find(params[:user_id])
    redirect_to group_join_group_path(@group)
  end
  
  def join_destroy
    @group = Group.find(params[:group_id])
    @group.users.delete(params[:user_id])
    redirect_to group_join_group_path(@group)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
    
  end

  def update
    if @group.update(group_params)
      redirect_to groups_user_path(current_user), notice: "グループを編集しました"
    else
      flash.now[:alert] = "グループの編集が失敗しました"
      render "edit"
    end
  end

  def post_index
    @group = Group.find(params[:group_id])
    @post = current_user.posts.new
    posts = @group.posts
    @posts = posts.filter do |post|
      post.user_id == current_user.id || post.is_status
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    @group.users.delete(current_user)
    redirect_to user_path(current_user.id)
  end
  
  def all_destroy
    @group = Group.find(params[:group_id])
    if @group.destroy
      redirect_to groups_user_path(current_user)
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  
  def correct_user
    @group = Group.find(params[:group_id] || params[:id])
    @user = @group.users
    redirect_to user_path(current_user.id) unless @group.owner_id == current_user.id
  end
  
  def limit_group
    @group_id = Group.find(params[:group_id]).id
    unless current_user.group_users.find_by(group_id: @group_id)
      redirect_to user_path(current_user.id)
    end
  end
end
