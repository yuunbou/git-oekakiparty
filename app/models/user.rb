class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  #has_many
  
  validates :nickname, length: { in: 2..20 }
  validates :introduction, length: { maximun: 200 }
  
end
