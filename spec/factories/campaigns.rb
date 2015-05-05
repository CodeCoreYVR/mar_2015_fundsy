FactoryGirl.define do
  factory :campaign do
    # this means I can create a campaign with the factory associated with 
    # a user as in:
    # create(:campaign, user: some_user) # assuming you have some_user created
    # adding the: factory: :user option makes it so if there isn't a user
    # passed in it will create one and assiciate the campaign with it
    association :user, factory: :user
    title Faker::Company.bs
    description Faker::Lorem.paragraph
    goal 1000000
    after(:build) {|c| c.reward_levels << FactoryGirl.create(:reward_level) }
  end

end
