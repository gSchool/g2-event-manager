class User < ActiveRecord::Base
  has_many :registrations
  has_many :created_events, -> {Registration.where({role: Registration.roles[:creator]})}, through: :registrations, source: :event
  has_many :attended_events, -> {Registration.where({role: Registration.roles[:guest]})}, through: :registrations, source: :event
  has_many :owned_events, -> {Registration.where({role: Registration.roles[:admin]})}, through: :registrations, source: :event
  has_many :waitlisted_events, -> {Registration.where({role: Registration.roles[:waitlist]})}, through: :registrations, source: :event
  has_secure_password
  has_many :events
  validates :email, presence: true
  validates :email, uniqueness: true
end