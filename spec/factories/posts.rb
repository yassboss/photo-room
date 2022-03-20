FactoryBot.define do
  factory :post do
    title              { Faker::Lorem.characters(number:10) }
    text               { Faker::Lorem.sentence }

    after(:build) do |post|
      post.images.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end

    trait :assoc do
      association :user
    end
  end
end
