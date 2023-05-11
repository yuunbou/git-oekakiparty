class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update, :group_post, :confirm, :withdraw]
  before_action :set_user, only: [:favorites]
  

  def show
    @user = User.find(params[:id])
    if @user.email == "guest@example.com" 
      redirect_to root_path
    end
    @favorite_posts = @user.favorite_posts.order(id: :desc).limit(5).published
    if @user.me?(current_user.id)
      @posts = @user.posts.where(post_type: 0).recent
    else
      @posts = @user.posts.where(post_type: 0).published.recent
    end
    
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user.id)
    else
      render :edit
    end
  end
  
  def confirm
    @user = User.find(params[:id])
    if @user.email == "guest@example.com" 
      redirect_to root_path
    end
  end
  
  def withdraw
    user = User.find(params[:id])
    user.update(is_active: false)
    reset_session
    redirect_to root_path
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorite_posts = @user.favorite_posts.page(params[:page]).published
  end

  def posts
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id).pluck(:id)
    if @user.me?(current_user.id)
      @posts = @user.posts.where(post_type: 0).order('id DESC').page(params[:page])
    else
      @posts = @user.posts.where(post_type: 0).order('id DESC').page(params[:page]).published
    end
  end
  
  def group_post
    @user = User.find(params[:id])
    @posts = @user.posts.where(post_type: 1).order('id DESC').page(params[:page])
  end

  def groups
    @user = User.find(params[:id])
    @groups = @user.groups.order('id DESC').page(params[:page]).per(10)
    @group_members = @user.group_members.where.not(owner_id: current_user.id).order('id DESC').page(params[:page]).per(10)
  end
  
  def index
    if params[:search].present? && params[:word].present?
      @users = User.search(params[:search], params[:word]).where(is_active:true).page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).where(is_active: true).per(10)
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :profile_image)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) unless @user == current_user
  end

  def set_user
    @user = User.find(params[:id])
  end

end
