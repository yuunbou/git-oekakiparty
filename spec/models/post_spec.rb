require 'rails_helper'

describe 'モデルのテスト' do
  it "有効な投稿内容の場合は保存されるか" do
    # FactoryBotのpost.rbで作成したダミーデータからpost_typeを上書きし、group_idを入れる
    post = FactoryBot.build(:post, post_type: 1, group_id: 1)
    # 上記のデータが有効であるかの確認
    expect(post).to be_valid
  end
end

