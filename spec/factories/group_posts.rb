FactoryBot.define do
  factory :group_post do
    group_title              { Faker::Lorem.characters(number:10) }
    group_text               { Faker::Lorem.sentence }

    trait :assoc do
      association :group
    end
  end
end
