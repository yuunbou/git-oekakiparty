require 'rails_helper'

describe 'モデルのテスト' do
  it "有効なユーザーの場合は保存されるか" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end