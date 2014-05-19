class User < ActiveRecord::Base
  has_many :attendances
  has_many :created_events, -> {Attendance.where({role: Attendance.roles[:creator]})}, through: :attendances, source: :event
  has_many :attended_events, -> {Attendance.where({role: Attendance.roles[:guest]})}, through: :attendances, source: :event
  has_many :owned_events, -> {Attendance.where({role: Attendance.roles[:admin]})}, through: :attendances, source: :event
  has_secure_password
  has_many :events
end