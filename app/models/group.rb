class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_one_attached :group_image
  has_many :posts

  validates :name, presence: true
  validates :content, presence: true
  validates :owner_id, presence: true

  def get_group_image(width, height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/no_group_image.jpg')
      group_image.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_limit:[width, height]).processed
  end

  def me?(user_id)
    id == user_id
  end

end
