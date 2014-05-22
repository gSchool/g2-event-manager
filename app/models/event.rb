class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendances
  has_many :users, through: :attendances

  def tickets_remaining
    self.capacity - number_of_attendees
  end

  def number_of_attendees
    self.attendances.where(role: Attendance.roles[:guest]).size
  end

end