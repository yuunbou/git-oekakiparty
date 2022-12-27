class Post < ApplicationRecord

  has_many_attached :images
  belongs_to :user

  enum type: { post_public: 0, post_private: 1 }
  # 投稿タイプ(0=個人投稿　1=グループ投稿)

  validates :images, presence: true
  validates :title, presence: true
  #タイトルのバリデーション
  #validates :is_status, presence: true

  scope :published, -> {where(is_status: true)}
  scope :unpublished, -> {where(is_status: false)}

  def me?(user_id)
    id == user_id
  end
end
