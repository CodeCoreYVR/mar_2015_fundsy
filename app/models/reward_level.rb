class RewardLevel < ActiveRecord::Base
  belongs_to :campaign, touch: true

  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :description, presence: true
end
