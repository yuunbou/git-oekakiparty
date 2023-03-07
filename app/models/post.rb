class Post < ApplicationRecord

  #アソシエーション
  has_many_attached :images
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  belongs_to :group, optional: true

  enum post_type: { post_public: 0, post_private: 1 }
  # 投稿タイプ(0=個人投稿　1=グループ投稿)

  validates :images, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  #validates :caption, allow_blank: true, length: { minimum: 10, maximum: 2000 }
  validates :caption, length: { maximum: 2000 }
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
  
  #検索の条件分岐　タグは部分一致と完全一致で検索　キーワードはタイトルとキャプションでのキーワード検索
  def self.search(method,word)
    if method == "partial_match"
      @words = word.split(/[[:blank:]]+/)
      
      #[]の中にeachの検索結果を収納
      posts = []
      @words.each do |word|
        tags = Tag.where("tag_name LIKE ?", "%#{word}%")
        tag_posts = PostTag.where(tag_id: tags.ids)
        posts = posts + tag_posts.pluck(:post_id)
        #+(プラス)...concatと同じ意味
      end
      
      @posts = Post.where(id: posts.uniq).where(post_type: 0).published

    elsif method == "perfect_match"
      @posts = Post.joins(:tags).merge(Tag.where(tag_name: word)).merge(Post.where(post_type: 0)).published
    elsif method == "keyword"
      @words = word.split(/[[:blank:]]+/)
      posts = []
      @words.each do |word|
        posts = posts.concat(Post.where("title LIKE(?) or caption LIKE(?)", "%#{word}%", "%#{word}%").ids)
        #concat.. 配列同士を結合するメソッド
      end
      @posts = Post.where(id: posts.uniq).where(post_type: 0).published
      #uniq..重複をなくすメソッド
    else
      @posts = Post.where(post_type: 0).published
    end
  end

end
