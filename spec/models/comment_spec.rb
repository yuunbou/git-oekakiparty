require 'rails_helper'

describe 'モデルのテスト' do
  it "有効なコメントの場合は保存されるか" do
    expect(FactoryBot.build(:comment)).to be_valid
  end
end