FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password Faker::Internet.password(12)
    # we use sequence when we need the attribute to be
    # unique because the factory will use the same values
    # when first defined. So it will use the same email
    # if we don't use sequence.
    sequence(:email) {|n| "awesome_email_#{n}@gmail.com" }
  end

end
