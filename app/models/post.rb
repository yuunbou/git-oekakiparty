class Post < ApplicationRecord

  has_many_attached :images
  belongs_to :user

  enum type: { post_public: 0, post_private: 1 }
  # 投稿タイプ(0=個人投稿　1=グループ投稿)

  validates :image, presence: true
  validates :title, presence: true
  #タイトルのバリデーション
  #validates :is_status, presence: true

end
