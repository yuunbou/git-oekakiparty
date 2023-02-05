class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update, :join_group]
  before_action :limit_group, only:[:post_index]
  
  #グループの新規作成
  def new
    @group = Group.new
  end

  #グループ作成
  def create
    @group = Group.new(group_params)
    #グループ作成者もメンバーに含ませるための記述
    @group.owner_id = current_user.id
    #@group.usersに、current_userを追加
    #グループにメンバーを追加するため
    @group.users << current_user
    if @group.save!
      redirect_to groups_user_path(current_user)
    else
      render 'new'
    end
  end
  
  #ユーザーリスト
  def join_group
    @group = Group.find(params[:group_id])
    @user = current_user
     #検索アクションはuserモデルに記載
    if params[:search].present? && params[:word].present?
      #where.notを使ってその条件に当てはまるもの以外を全て取得
      @users = User.search(params[:search], params[:word]).where.not(id: @group.owner_id).where.not(is_active: false).page(params[:page]).per(10)
    else
      @users = User.where.not(id: @group.owner_id).where.not(is_active: false).page(params[:page]).per(10)
    end
  end
  
  #グループ作成者がユーザーを追加するアクション
  def join_user
    @group = Group.find(params[:group_id])
    # User.find(params[:user_id])で追加したいユーザーのデータを取得する
    @group.users << User.find(params[:user_id])
    redirect_to group_join_group_path(@group)
  end
  
  #グループ作成者がユーザーをグループから外すアクション
  def join_destroy
    @group = Group.find(params[:group_id])
    @group.users.delete(params[:user_id])
    redirect_to group_join_group_path(@group)
  end

  #グループ内の詳細
  def show
    @group = Group.find(params[:id])
  end

  #グループの編集
  def edit
    @group = Group.find(params[:id])
    
  end

  #グループ内容の更新
  def update
    if @group.update(group_params)
      redirect_to groups_user_path(current_user)
    else
      render "edit"
    end
  end

  #グループ内投稿ページ
  def post_index
    @group = Group.find(params[:group_id])
    @post = current_user.posts.new
    posts = @group.posts
    @posts = posts.filter do |post|
      post.user_id == current_user.id || post.is_status
    end
  end
  
  #ユーザーが自主的にグループから抜ける為のアクション
  def destroy
    @group = Group.find(params[:id])
    #current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to user_path(current_user.id)
  end
  
  #グループを消すアクション
  def all_destroy
    @group = Group.find(params[:group_id])
    if @group.destroy
      redirect_to groups_user_path(current_user)
    end
  end

  private

  #フォームから渡す必要がないためowner_idはparamsに入れる必要がない
  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  
  def correct_user
    @group = Group.find(params[:group_id] || params[:id])
    @user = @group.users
    redirect_to user_path(current_user.id) unless @group.owner_id == current_user.id
  end
  
  def limit_group
    #グループのidだけを持ってくる
    @group_id = Group.find(params[:group_id]).id
    #current_userがグループのidを持っていたらpost_indexにアクセスできる
    unless current_user.group_users.find_by(group_id: @group_id)
      redirect_to user_path(current_user.id), notice: 'グループに参加してください'
    end
  end
end
