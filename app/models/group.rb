class Group < ApplicationRecord
  has_one_attached :group_image
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, dependent: :destroy
  has_many :posts, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 500 }
  
  #グループイメージの画像
  def get_group_image(width, height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_group_image.jpg')
      group_image.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_limit:[width, height]).processed
  end
end
