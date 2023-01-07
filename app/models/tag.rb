class Tag < ApplicationRecord

  has_many :posts, through: :post_tags
  #through経由でpostsにアクセスできるようにする
  has_many :post_tags, dependent: :destroy


end
