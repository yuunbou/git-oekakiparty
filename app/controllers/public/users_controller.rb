class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only:[:edit, :update]
  before_action :set_user, only: [:favorites]


  def show
    @user = User.find(params[:id])
    
    #ゲストログインはマイページへ遷移できない
    if @user.email == "guest@example.com" 
      redirect_to root_path
    end
    # where→条件に一致したカラムをすべて取得
    # find→条件に一致したカラムを1件だけ取得
    #whereで絞り込んだデータからpluckでpost_idの配列を作る
    #where→order→pluckの順で記述
    favorites = Favorite.where(user_id: @user.id).order(id: :desc).limit(5).pluck(:post_id)
    @favorite_posts = Post.find(favorites)

    #今ログインしているのが自分か確認
    if @user.me?(current_user.id)
      #whereを使ってpostモデルで設定したenumのpost_typeの0:個人投稿を検索し、自分だったら全て表示
      @posts = @user.posts.where(post_type: 0).recent
      
    else
      #published = postモデルのscopeで定義した投稿のステータスがtrue(公開)
      #公開中のもののみ他人に表示される 非公開は他のユーザーに表示されない
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
  
  #退会画面
  def confirm
    @user = User.find(params[:id])
  end
  
  #退会処理
  def withdraw
    user = User.find(params[:id])
    user.update(is_active: false)
    reset_session
    redirect_to root_path
  end
  
  #いいね一覧
  def favorites
    @user = User.find(params[:id])
#    @favorites = Favorite.where(user_id: @user.id).page(params[:page]).pluck(:post_id)
    #＠favorites_posts..userモデルファイルで定義
    @favorite_posts = @user.favorite_posts.page(params[:page]) #Post.find(@favorites)
  end

  #ユーザーの投稿一覧
  def posts
    @user = User.find(params[:id])
    #pluck = 指定したカラム(この場合post_id)のレコードの配列を取得
    @posts = Post.where(user_id: @user.id).pluck(:post_id)
    #今ログインしているのが自分か確認
    if @user.me?(current_user.id)

      #whereを使ってpost_typeを検索して投稿した自分だったら全てを表示する
      @posts = @user.posts.where(post_type: 0).page(params[:page])
    else
     #公開中のもののみ他人に表示される 非公開は他人に表示されない
      @posts = @user.posts.where(post_type: 0).page(params[:page]).published
    end
  end
  
  def group_post
    @user = User.find(params[:id])
    @posts = @user.posts.where(post_type: 1).page(params[:page])
  end
  
  
  

  #グループ一覧
  def groups
    @user = User.find(params[:id])
    #@groups= GroupUser.where(user_id: @user.id).page(params[:page]).pluck(:group_id)
    #アソシエーションでgroupは持っているためwhereを使わずとも下記の定義でとってこれる
    @groups = @user.groups.page(params[:page])#Group.find(groups)
  end
  
  #ユーザー一覧
  def index
    if params[:search].present? && params[:word].present?
      #Userモデルファイルにsearchとwordを定義
      #ページネーション。。。per()で個別にページネーションを指定できる
      @users = User.search(params[:search], params[:word]).page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(10)
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :introduction, :profile_image)
  end

  #correct_user = レコードを本当にログインユーザの所有しているものかを判別するメソッド
  def correct_user
    @user = User.find(params[:id])
    redirect_to user_path(current_user.id) unless @user == current_user
  end

  #favorites用
  def set_user
    @user = User.find(params[:id])
  end
  
  

end
