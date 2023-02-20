FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number:10) }
    caption { Faker::Lorem.characters(number:30) }
    post_type { 0 }
    association :user
    after(:build) do |post|
      post.images.attach(io: File.open('spec/fixtures/sample_image.jpg'), filename: 'sample_image.jpg', content_type: 'image/jpg')
    end
  end
end
