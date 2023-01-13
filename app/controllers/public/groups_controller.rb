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
    @group.owner_id = current_user.id
    @group.users << current_user
    #グループ作成者もメンバーに含ませるための記述
    if @group.save!
      redirect_to groups_path
    else
      render 'new'
    end
  end

  #作成したグループの一覧
  def index
    @groups = Group.where(id: current_user)
    #グループの一覧は作成者のみのものを表示
  end

  #グループ内の詳細（投稿したものなど）
  def show
    @group = Group.find(params[:id])
  end

  #グループの編集
  def edit
    @group = Group.find(params[:id])
  end

  #グループ編集の更新
  def update
    if @group.update(group_params)
      redirect_to groups_path
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


  private

  def group_params
    params.require(:group).permit(:name, :content, :group_image)
  end

  def correct_user
    @group = Group.find(params[:id])
    @user = @group.user
    redirect_to(posts_path) unless @group.owner_id == current_user.id
  end

end
