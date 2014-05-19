class User < ActiveRecord::Base
  has_secure_password
  has_many :events
  validates :email, presence: true
end