class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: nil) }
end
