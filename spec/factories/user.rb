FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    nickname { Faker::Lorem.characters(number:10) }
    password { 'testsample' }
  end
end