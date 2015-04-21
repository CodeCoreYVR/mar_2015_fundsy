class Campaign < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  validates :goal, numericality: {greater_than_or_equal_to: 10}
end
