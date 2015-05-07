class Pledge < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :campaign

  validates :amount, numericality: {greater_than_or_equal_to: 1}

  aasm do
    state :pending, initial: true
    state :paid
    state :cancelled
    state :refunded

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :refund do
      transitions from: :paid, to: :refunded
    end

    event :cancel do
      transitions from: :pending, to: :cancelled
    end

  end

end
