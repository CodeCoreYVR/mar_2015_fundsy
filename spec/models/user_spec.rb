require 'rails_helper'

# RSpec describe takes in either a class such as User or UserController
# which will make it easier to integrate with it.
# You can also give it just a string, which mean there is no specific integration
# This way it can be used to group things together.
# there are aliases for describe such as 'context'
RSpec.describe User, type: :model do

  describe "Validations" do

    def valid_attributes(new_attributes = {})
      attributes = {first_name: "Tam", 
                    last_name: "Kbeili", 
                    email: "tam@codecore.ca"}
      attributes.merge(new_attributes)
    end

    # "it" is used to define a test scenario (or test case)
    # "specify" is an alias for it.
    it "requires an email" do
      user = User.new(valid_attributes({email: nil}))
      # be_invalid is an RSpec matcher
      expect(user).to be_invalid
    end

    it "requires a first name" do
      user = User.new(valid_attributes({first_name: nil}))
      expect(user).to be_invalid
    end

    it "requires a unique email" do
      User.create(valid_attributes)
      user = User.new(valid_attributes)
      user.save
      expect(user.errors.messages).to have_key(:email)
    end

    it "requires a valid email" do
      user = User.new(valid_attributes(email: "blabla"))
      expect(user).to be_invalid
    end

  end

end
