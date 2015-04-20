class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, email: true
  validates :first_name, presence: true

end
