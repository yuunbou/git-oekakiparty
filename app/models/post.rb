class Post < ApplicationRecord

  #アソシエーション
  has_many_attached :images
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  belongs_to :group, optional: true
  #optional: true　＝　なくても保存できますよという記述
  #groupとのアソシエーション

  enum post_type: { post_public: 0, post_private: 1 }
  # 投稿タイプ(0=個人投稿　1=グループ投稿)

  validates :images, presence: true
  validates :title, presence: true
  #タイトルのバリデーション
  #validates :is_status, presence: true

  # 公開・非公開の設定
  scope :published, -> {where(is_status: true)}
  #scope　：published　= 下記の内容をpublishedという一つのメソッドとして定義
  #postのテーブルからwhereでis_statusカラムを検索し、true(公開)
  scope :unpublished, -> {where(is_status: false)}
  #postのテーブルからwhereでis_statusカラムを検索し、false(公開)

  scope :recent, -> { order(id: :desc).limit(5) }
  #recent = マイページの投稿一覧の表示件数の定義

  #今ログインしているのが本人か確認する
  def me?(user_id)
    id == user_id
  end

  #いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #紐付けながら保存
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
      #self = postモデルのこと
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_post_tag
    end
  end
  #検索の条件分岐　タグは部分一致と完全一致で検索　キーワードはタイトルとキャプションでのキーワード検索にしたい
  def self.search(method,word)
    #byebug
    if method == "partial_match"
      @words = word.split(/[[:blank:]]+/)
      
      #[]の中にeachの検索結果を収納
      posts = []
      @words.each do |word|
      #joinsでpostとtagを結合させ、mergeでテーブルの検索の条件をつける
      #@モデルs = モデル名.joins(:結合させるモデル名s).merge(モデル名.where(カラム名 検索の条件)).merge(検索条件を増やしたい場合mergeで増やしていく)
        #@posts = Post.joins(:tags).merge(Tag.where("tag_name LIKE ?", "%#{word}%")).merge(Post.where(post_type: 0)).published
        
        tags = Tag.where("tag_name LIKE ?", "%#{word}%")
        tag_posts = PostTag.where(tag_id: tags.ids)
        posts = posts + tag_posts.pluck(:post_id)
      end
      
      @posts = Post.where(id: posts).where(post_type: 0).page(params[:page]).published

    elsif method == "perfect_match"
      @posts = Post.joins(:tags).merge(Tag.where(tag_name: word)).merge(Post.where(post_type: 0)).page(params[:page]).published
    elsif method == "keyword"
      #@word = "title"
      #@word = @word.split(/[[:blank:]]+/)
      #@words.each do |word|
        @posts = Post.where("title LIKE(?) or caption LIKE(?)", "%#{word}%", "%#{word}%").where(post_type: 0).page(params[:page]).published
      #end
      #{word}の部分を別の変数名に変更
    else
      @posts = Post.where(post_type: 0).page(params[:page]).published
    end
    @posts
  end

end
