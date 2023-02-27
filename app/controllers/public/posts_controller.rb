class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update, :destroy]

  def new
    @post = current_user.posts.new
    # ゲストログインは投稿画面に遷移できない
    if current_user.email == "guest@example.com" 
      redirect_to root_path
    end
  end

  def create
    @post = current_user.posts.new(post_params)
    # postにgroup_idがあるかないか？確認
    if @post.group_id.nil?
      # 投稿のタイプ（個人投稿）
      @post.post_type = "post_public"
      tag_list = params[:post][:tag_name].split(/[[:blank:]]/)
      if @post.save
        @post.save_tag(tag_list)
        #group_idが空の場合はpostのshowに移動
        redirect_to post_path(@post.id), notice: "投稿が成功しました"
      else
        flash.now[:alert] = "投稿が失敗しました"
        render 'public/posts/new'
      end
    else
      # 投稿タイプ = "グループ内投稿"
      @post.post_type = "post_private"
      if @post.save
        # post_privateで投稿されたらgroup_post_index_pathに移動する
        # もしgroup_idが入っていたらgroup_post_indexに移動する
        #flash[:notice] = "登録しました"
        redirect_to group_post_index_path(@post.group), notice: "投稿が成功しました"
      else
        @group = @post.group
        @posts = @group.posts
        flash.now[:alert] = "投稿に失敗しました"
        render 'public/groups/post_index'
      end
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @user = @post.user
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts
    else
      @posts = Post.where(post_type: 0).published
    end

  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name)
  end

  def update
    @post = Post.find(params[:id])
    if @post.group_id.nil?
      @post.post_type = "post_public"
      tag_list = params[:post][:tag_name].split(/[[:blank:]]/)
      if @post.update(post_params)
        @post.save_tag(tag_list)
        redirect_to post_path(@post.id), notice: "投稿を編集しました"
      else
        flash.now[:alert] = "編集に失敗しました"
        render :edit
      end
    else
      @post.post_type = "post_private"
      if @post.update(post_params)
        redirect_to group_post_index_path(@post.group), notice: "投稿を編集しました"
      else
        flash.now[:alert] = "編集に失敗しました"
        render :edit
      end
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy
    redirect_to posts_user_path(current_user.id)
  end

  # 検索ページ
  def search_index
    # タグのリンクを押した場合
    if params[:tag_id].present?
      @tag = Tag.find(params[:tag_id])
      @posts = @tag.posts.page(params[:page]).published
    #＆＆を使うことでxx かつという意味になる
    elsif params[:search].present? && params[:word].present?
      @posts = Post.search(params[:search], params[:word]).order('id DESC').page(params[:page])
    else
      @posts = Post.where(post_type: 0).order('id DESC').page(params[:page]).published
    end

  end

  private

  def post_params
    params.require(:post).permit(:group_id, :title, :caption, :is_status, :post_type, images: []).merge(user_id: current_user.id)
  end

  # correct_userとは・・レコードを本当にログインユーザの所有しているものかを判別するメソッド
  # レコードの編集、更新、削除など、持ち主しかやってはいけない機能を作るときによく使う
  def correct_user
    @post = Post.find(params[:id])
    @user = @post.user
    redirect_to user_path(current_user.id) unless @user == current_user
  end

end
