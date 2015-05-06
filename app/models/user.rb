class User < ActiveRecord::Base
  has_secure_password

  has_many :campaigns, dependent: :nullify
  has_many :pledges, dependent: :nullify
  has_many :groups, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :joined_groups, through: :memberships, source: :group

  validates :email, presence: true, uniqueness: true, email: true
  validates :first_name, presence: true

  geocoded_by :address
  after_validation :geocode

  before_create :generate_api_key

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while User.exists?(api_key: api_key)
  end

end
