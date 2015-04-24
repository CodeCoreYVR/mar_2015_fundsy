class Group < ActiveRecord::Base
  belongs_to :user

  has_many :memberships, dependent: :destroy
  has_many :member_users, through: :memberships, source: :user
end
