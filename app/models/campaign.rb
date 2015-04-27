class Campaign < ActiveRecord::Base
  belongs_to :user
  has_many :pledges, dependent: :nullify

  has_many :reward_levels, dependent: :destroy

  # this allows creating reward_levels at the same time
  # you create a campaign. reject_if option will make it so
  # if the reward_level attributes are empty it will just igonore it
  # the allow_destroy option will make it so if you pass in _destroy
  # attribute it will delete the reward level
  accepts_nested_attributes_for :reward_levels,
                                reject_if: lambda {|x|
                                  x[:amount].blank? &&
                                  x[:description].blank?
                                }, allow_destroy: true
  validates :reward_levels, presence: true

  validates :title, presence: true
  validates :description, presence: true

  validates :goal, numericality: {greater_than_or_equal_to: 10}

  scope :most_recent, lambda {|x| order("created_at DESC").limit(x) }

end
