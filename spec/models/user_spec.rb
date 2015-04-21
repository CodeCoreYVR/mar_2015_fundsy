require 'rails_helper'

# RSpec describe takes in either a class such as User or UserController
# which will make it easier to integrate with it.
# You can also give it just a string, which mean there is no specific integration
# This way it can be used to group things together.
# there are aliases for describe such as 'context'
RSpec.describe User, type: :model do
  def valid_attributes(new_attributes = {})
    # We can also do
    # attributes = FactoryGirl.attributes_for(:user)
    # or
    # attributes = attributes_for(:user)
    attributes = {first_name: "Tam", 
                  last_name: "Kbeili", 
                  email: "tam@codecore.ca",
                  password: "abcd1234"}
    attributes.merge(new_attributes)
  end

  describe "Validations" do


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

  describe "Hashing password" do
    it "generates password digest if given a password" do
      user = User.new valid_attributes
      user.save
      expect(user.password_digest).to be
    end
  end

  describe ".full_name" do
    it "returns the concatenated first name and last name if both are given" do
      u = User.new valid_attributes
      expect(u.full_name).to eq("#{valid_attributes[:first_name]} #{valid_attributes[:last_name]}")
    end

    it "returns the first name only if only first name is given" do
      u = User.new valid_attributes({last_name: nil})
      expect(u.full_name).to eq(valid_attributes[:first_name])
    end
  end

end
