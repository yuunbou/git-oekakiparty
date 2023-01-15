class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users



  validates :nickname, presence: true, length: { in: 2..20 }
  validates :introduction, length: {maximum: 300 }
  validates :email, uniqueness: true


  #プロフィール画像設定
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width, height]).processed
  end

  #マイページ（show）アクションで使用
  def me?(user_id)
    id == user_id
  end

  #検索の条件分岐　部分一致と完全一致で検索
  def self.search(method,word)
    #byebug
    if method == "partial_match"
      @users = User.where("nickname LIKE ?", "%#{word}%")
      #joinsでpostとtagを結合させ、mergeでテーブルの検索の条件をつける
      #@モデルs = モデル名.joins(:結合させるモデル名s).merge(モデル名.where(カラム名 検索の条件)).merge(検索条件を増やしたい場合mergeで増やしていく)
    elsif method == "perfect_match"
      @users = User.where(nickname: word)
    else
      @users = User.all
    end
  end

end
