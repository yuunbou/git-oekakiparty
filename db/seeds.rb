#管理者用ログイン
Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'adminoekakiparty'
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# ユーザーの作成
user_attributes = (1..30).map do |n|
    {
      email: "test#{n}@example.com",
      password: "testtest",
      nickname: "test#{n}",
      is_active: "true"
    }
end

user_attributes.each do |user_attribute|
    User.find_or_create_by(email: user_attribute[:email]) do |user|
        user.password = user_attribute[:password]
        user.nickname = user_attribute[:nickname]
        user.is_active = user_attribute[:is_active]
    end
end

# user = User.create!(
#     email: "test@example.com",
#     password: "testtest",
#     nickname: "test太郎",
#     is_active: "true"
# )

# User.create!(
#     email: "sample@example.com",
#     password: "samplesample",
#     nickname: "sample花子",
#     is_active: "true"
# )

# 個人投稿のpostを作成

post_attributes = (1..5).map do |n|
  {
    title: "test#{n}投稿",
    post_type: 0,
    caption: "サンプルキャプション"
  }
end

User.all.pluck(:id).flat_map do |user_id|
    post_attributes.map { |post_attribute| post_attribute.merge(user_id: user_id) }
end.each do |post_attribute|
    Post.create(
      post_attribute.merge(
          images: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/no_group_image.jpg"), filename: "no_group_image.jpg")
      )
    )
end

# postタグの作成
Post.all.each do |post|
  (1..4).each do |n|
    post.tags.create(tag_name:"タグサンプル#{n}")
  end
end

# グループの作成
# group1 = user.groups.create!(
#     name: "testグループ",
#     content: "サンプルグループ内容"
# )
    
# グループ内投稿の作成
# user.posts.create!(
#     title: "grouptest投稿",
#     post_type: 1,
#     caption: "グループ内投稿サンプルキャプション",
#     group_id: 1
# )

# GroupUser.create!(
#     user_id: 1,
#     group_id: 1
# )

