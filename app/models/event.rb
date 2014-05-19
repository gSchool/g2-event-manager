class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendances
  has_many :users, through: :attendances
end