class Post < ApplicationRecord

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

end
