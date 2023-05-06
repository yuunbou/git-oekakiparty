class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, :source => :post
  has_many :comments, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :group_members, through: :group_users, :source => :group
  has_many :my_groups, through: :group_users, dependent: :destroy
  has_many :groups, foreign_key: :owner_id

  validates :nickname, presence: true, length: { in: 2..20 }
  validates :introduction, length: {maximum: 300 }
  validates :email, uniqueness: true

  #ゲストログイン
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "ゲストユーザー"
    end
    redirect_to root_path
  end

  #プロフィール画像設定
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io:File.open(file_path),filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width, height]).processed
  end

  #マイページ(show)使用
  def me?(user_id)
    id == user_id
  end

  #検索フォーム
  def self.search(method,word)
    if method == "partial_match"
      @users = User.where("nickname LIKE ?", "%#{word}%").where(is_active: true)
    elsif method == "perfect_match"
      @users = User.where(nickname: word).where(is_active: true)
    else
      @users = User.where(is_active: true)
    end
  end

end
