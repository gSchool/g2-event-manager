class Event < ActiveRecord::Base
  belongs_to :user
  has_many :registrations
  has_many :users, through: :registrations

  def tickets_remaining
    self.capacity - number_of_registrations
  end

  def number_of_registrations
    self.registrations.where(role: Registration.roles[:guest]).size
  end

  def waitlist
    self.users.where('registrations.role = ?', Registration.roles[:waitlist])
  end

  def add_to_waitlist(user)
    self.registrations.create(user: user, role: Registration.roles[:waitlist])
  end

  def remove_from_waitlist(user)
    self.registrations.find_by(user: user, role: Registration.roles[:waitlist]).destroy
  end

end