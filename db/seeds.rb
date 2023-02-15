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
user = User.create!(
    email: "test@example.com",
    password: "testtest",
    nickname: "test太郎",
    is_active: "true"
)

User.create!(
    email: "sample@example.com",
    password: "samplesample",
    nickname: "sample花子",
    is_active: "true"
)

# 個人投稿のpostを作成
post1 = user.posts.create!(
    title: "test投稿",
    post_type: 0,
    images: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/no_group_image.jpg"),
    filename: "no_group_image.jpg"),
    caption: "サンプルキャプション"
)

# postタグの作成
post1.tags.create!(
    tag_name:"sample"
)

# グループの作成
group1 = user.groups.create!(
    name: "testグループ",
    content: "サンプルグループ内容"
)
    
# グループ内投稿の作成
user.posts.create!(
    title: "grouptest投稿",
    post_type: 1,
    images: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/no_group_image.jpg"),
    filename: "no_group_image.jpg"),
    caption: "グループ内投稿サンプルキャプション",
    group_id: 1
)

GroupUser.create!(
    user_id: 1,
    group_id: 1
)

