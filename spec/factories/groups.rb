FactoryBot.define do
  factory :group do
    name              { Faker::Name.name }
    introduction      { Faker::Lorem.sentence }
  end
end
