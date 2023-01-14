class Tag < ApplicationRecord

  #through経由でpostsにアクセスできるようにする
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  #上から見ていくため記述の順次気を付ける

end
