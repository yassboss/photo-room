FactoryBot.define do
  factory :group_user do
    trait :assoc do
      association :user
      association :group
    end
  end
end
