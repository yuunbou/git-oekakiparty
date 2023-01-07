class Post < ApplicationRecord

  #アソシエーション
  has_many_attached :images
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  enum post_type: { post_public: 0, post_private: 1 }
  # 投稿タイプ(0=個人投稿　1=グループ投稿)

  validates :images, presence: true
  validates :title, presence: true
  #タイトルのバリデーション
  #validates :is_status, presence: true

  # 公開・非公開の設定
  scope :published, -> {where(is_status: true)}
  # ↑is_statusカラムがtrueであるものを
  scope :unpublished, -> {where(is_status: false)}

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

end
