class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post
  
  validates :comment, presence: true, length: { maximum: 1000 }
  # validates :comment, allow_blank: true, length: { minimum: 10, maximum: 2000 }
  
end
