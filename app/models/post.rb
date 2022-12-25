class Post < ApplicationRecord
  
  has_many_attached :image
  belongs_to :user
  
  
  
end
