class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  
  #グループの新規作成
  #グループの部屋を作る
  def new
    @group = Group.new
  end

  #グループ作成
  def create
    @group = Group.new(group_params)
    #@group.usersに、current_userを追加
    #グループ作成者もメンバーに含ませるための記述
    @group.owner_id = current_user.id
    
     #グループにメンバーを追加するため
    @group.users << current_user
    if @group.save!
      redirect_to groups_user_path(current_user)
    else
      render 'new'
    end
  end
  
  #加入追記
  def join 
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  group_path(@group.id)
  end
  

  #グループ内の詳細（投稿したものなど）
  def show
    @group = Group.find(params[:id])
    #@group.owner_id = current_user.id
  end

  #グループの編集
  def edit
    @group = Group.find(params[:id])
    @group_users = GroupUser.where(user_id: @user.ids)
    #リストからユーザーを持ってきて追加するイメージ
  end

  #グループ編集の更新 ユーザーの追加
  def update
    @group_users = GroupUser.where(user_id: @user.ids)
    if @group.update(group_params)
      redirect_to groups_user_path(current_user)
    else
      render "edit"
    end
  end

  def post_index
    @group = Group.find(params[:group_id])
    @post = current_user.posts.new
    @posts = @group.posts
    #Postモデルwhereで検索してgroup_idを元にして取り出す

  end
  
  def destroy
    @group = Group.find(params[:id])
    #current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to user_path(current_user.id)
  end


  private

  #フォームから渡す必要がないためowner_idはparamsに入れる必要がない
  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end
  

  def correct_user
    @group = Group.find(params[:id])
    @user = @group.users
    redirect_to(posts_path) unless @group.owner_id == current_user.id
  end

end
