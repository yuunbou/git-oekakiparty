require 'rails_helper'

describe 'モデルのテスト' do
  it "有効なグループの場合は保存されるか" do
    expect(FactoryBot.build(:group)).to be_valid
  end
end