require 'rails_helper'

RSpec.describe Campaign, type: :model do
  def valid_attributes(new_attributes)
    attributes = {title: "Potato Salad 2.0",
                  goal: 100000000,
                  description: "Jared likes Mayonase",
                  ends_on: (Time.now + 30.days)}
    attributes.merge(new_attributes)
  end

  describe "validations" do
    it "requires a title" do
      c = Campaign.new(valid_attributes(title: nil))
      expect(c).to be_invalid
    end

    it "requires a description" do
      c = Campaign.new(valid_attributes(description: nil))
      expect(c).to be_invalid
    end

    it "requires a numerical goal" do
      c = Campaign.new(valid_attributes(goal: "asdf"))
      expect(c).to be_invalid
    end

    it "requires the goal to be $10 or more" do
      c = Campaign.new(valid_attributes(goal: 5))
      c.save
      expect(c.errors.messages).to have_key(:goal)
    end

  end
end
