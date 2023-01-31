class Public::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  
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
  
  #ユーザーがグループに加入するアクション
  def join 
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  group_path(@group.id)
  end
  
  #ユーザーリスト
  def join_group
    @group = Group.find(params[:group_id])
    @user = current_user
     #検索フォーム
    if params[:search].present? && params[:word].present?
      #Userモデルファイルにsearchとwordを定義
      #where.notを使ってその条件に当てはまるもの以外を全て取得
      @users = User.search(params[:search], params[:word]).where.not(id: @group.owner_id).page(params[:page]).per(10)
    else
      @users = User.where.not(id: @group.owner_id).page(params[:page]).per(10)
    end
  end
  
  #グループ作成者がユーザーを追加するアクション
  def join_user
    @group = Group.find(params[:group_id])
    @group.users << User.find(params[:user_id])
    # @group.users << params[:user_id] # ここを変える.追加したいユーザーのデータを取得する → userのidが必要
    # 上記のコードではダメです. params[:user_id] を使ってユーザーのデータを取得する必要があります
    redirect_to group_join_group_path(@group)
  end
  
  #グループ作成者がユーザーをグループから外すアクション
  def join_destroy
    @group = Group.find(params[:group_id])
    #()の中にuserの引数を入れる
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
    @group_users = GroupUser.where(user_id: @user.ids)
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

  #グループ内投稿ページ
  def post_index
    @group = Group.find(params[:group_id])
    @post = current_user.posts.new
    #共通化
    in_group_status(@group)
    #作った人のowner_idとログインしているユーザーのidが同じだった場合
    #if @group.owner_id == current_user.id
      #全て表示
     # @posts = @group.posts
    #else
      #publishedのみ表示
      #@posts = @group.posts.published
    #end

  end
  
  #ユーザーが自主的にグループから抜ける為のアクション
  def destroy
    @group = Group.find(params[:id])
    #current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to user_path(current_user.id)
  end
  
  #グループ自体を消すアクション
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
    @group = Group.find(params[:id])
    @user = @group.users
    redirect_to(posts_path) unless @group.owner_id == current_user.id
  end
  
  def in_group_status(group)
    if group.owner_id == current_user.id
      #全て表示
      @posts = @group.posts
    else
      #publishedのみ表示
      @posts = group.posts.published
    end
  end
end
