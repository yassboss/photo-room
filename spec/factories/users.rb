FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password              { '1234test' }
    password_confirmation { password }
    last_name             { Faker::Name.last_name }
    first_name            { Faker::Name.first_name }
    main_camera           { Faker::Commerce.product_name }
    prefecture_id         { Faker::Number.between(from: 2, to: 48) }
    camera_experience_id  { Faker::Number.between(from: 2, to: 8) }

    after(:build) do |user|
      user.avatar.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
