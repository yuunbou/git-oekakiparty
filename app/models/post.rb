class Post < ApplicationRecord

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
  validates :caption, length: { maximum: 2000 }
  

  # 公開・非公開の設定
  scope :published, -> {where(is_status: true)}
  # postのテーブルからwhereでis_statusカラムを検索し、false(公開)
  scope :unpublished, -> {where(is_status: false)}
  
  # recent = マイページの投稿一覧の表示件数
  scope :recent, -> { order(id: :desc).limit(5) }
  

  #今ログインしているのが本人か確認する
  def me?(user_id)
    id == user_id
  end

  #いいね機能
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_post_tag
    end
  end
  
  # 検索機能
  def self.search(method,word)
    if method == "partial_match"
      @words = word.split(/[[:blank:]]+/)
      
      posts = []
      @words.each do |word|
        tags = Tag.where("tag_name LIKE ?", "%#{word}%")
        tag_posts = PostTag.where(tag_id: tags.ids)
        posts = posts + tag_posts.pluck(:post_id)
      end
      
      @posts = Post.where(id: posts.uniq).where(post_type: 0).published

    elsif method == "perfect_match"
      @posts = Post.joins(:tags).merge(Tag.where(tag_name: word)).merge(Post.where(post_type: 0)).published
    elsif method == "keyword"
      @words = word.split(/[[:blank:]]+/)
      posts = []
      @words.each do |word|
        posts = posts.concat(Post.where("title LIKE(?) or caption LIKE(?)", "%#{word}%", "%#{word}%").ids)
      end
      @posts = Post.where(id: posts.uniq).where(post_type: 0).published
    else
      @posts = Post.where(post_type: 0).published
    end
  end

end
