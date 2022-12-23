class Public::HomesController < ApplicationController

  def top
  end

  def about
  end
  
  def guest_sign_in
    user = user.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
  end

    
end
