class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]

  def new
      @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.group_id.nil?
      #postにgroup_idがあるかないか？
      #投稿のタイプ（個人投稿）
      @post.post_type = "post_public"
      tag_list = params[:post][:tag_name].split(/[[:blank:]]/)
      if @post.save!
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id)
        #group_idが空の場合はpostのshowに移動
      end
    else
      #投稿タイプ（グループ内投稿）
      @post.post_type = "post_private"
      @post.save!
      redirect_to group_post_index_path(@post.group)
      #post_privateで投稿されたらgroup_post_index_pathに移動する
      #もしgroup_idが入っていたらgroup_post_indexに移動する
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name)
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split(/[[:blank:]]/)
    if @post.update(post_params)
      @post.save_tag(tag_list)
      redirect_to post_path(@post.id)
    else
        render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  #検索アクション
  def index
    #タグのリンクを押した場合
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts
      #.order(created_at: :desc)
      #order＝並び順　:descだったら大きい順　:ascで小さい順
    #＆＆を使うことでxx かつという意味になる
    elsif params[:search].present? && params[:word].present?
      @posts = Post.search(params[:search], params[:word])
    else
      @posts = Post.where(post_type: 0).published
    end
  end

  private

  def post_params
    params.require(:post).permit(:group_id, :title, :caption, :is_status, :post_type, images: []).merge(user_id: current_user.id)
  end

  #correct_userとは・・レコードを本当にログインユーザの所有しているものかを判別するメソッド
  #レコードの編集、更新、削除など、持ち主しかやってはいけない機能を作るときによく使う
  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    redirect_to(posts_path) unless @user == current_user
  end


end
