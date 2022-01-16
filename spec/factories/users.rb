FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password = Faker::Internet.password(min_length: 6)
    password              { password }
    password_confirmation { password }
    image                 { Rack::Test::UploadedFile.new(File.join(Rails.root, 'public/uploads/test_image.png')) }
    last_name             { Faker::Name.last_name }
    first_name            { Faker::Name.first_name }
    main_camera           { Faker::Commerce.product_name }
    prefecture_id         { Faker::Number.between(from: 2, to: 48) }
    camera_experience_id  { Faker::Number.between(from: 2, to: 8) }
  end
end
