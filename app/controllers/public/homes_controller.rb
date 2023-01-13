class Public::HomesController < ApplicationController

  def top
    @posts = Post.where(post_type: 0).published.order('id DESC').limit(4)
  end

  def about
  end

  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "ゲストユーザー"
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end


end
