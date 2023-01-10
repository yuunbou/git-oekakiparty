class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_one_attached :group_image

  validates :name, presence: true
  validates :content, presence: true
  validates :owner_id, presence: true

end
