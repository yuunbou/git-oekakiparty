FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number:10) }
    content { Faker::Lorem.characters(number:30) }
    #FactoryBot.createでuserを作成し、ownerに割り当てる
    owner { FactoryBot.create(:user)}
  end
end