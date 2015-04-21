FactoryGirl.define do
  factory :campaign do
    title Faker::Company.bs
    description Faker::Lorem.paragraph
    goal 1000000
  end

end
