require 'carrierwave/orm/activerecord'

class Event < ActiveRecord::Base

  validates :name, :date, :description, :location, :capacity, :category, :presence => true

  mount_uploader :event_pic, EventPictureUploader

  belongs_to :user
  has_many :registrations
  has_many :users, through: :registrations

  def self.search(query)
    where("city iLIKE ?", "%#{query}%")
  end

  def self.registration_role(user, event)
    registration = Registration.find_by(user_id: user.id, event_id: event.id)
    registration.role
  end

  def tickets_remaining
    self.capacity - number_of_registrations
  end

  def number_of_registrations
    self.registrations.where(role: Registration.roles[:guest]).size
  end

  def self.to_ics(events, user)
    ics_string = "BEGIN:VCALENDAR\nVERSION:2.0\nPRODID:-//hacksw/handcal//NONSGML v1.0//EN\n"
    events.each do |event|
      role = registration_role(user, event)
      start_time = format_time(event.date, event.start_time)
      end_time = format_time(event.date, event.end_time)
      ics_string << "BEGIN:VEVENT\n"
      ics_string << "UID:#{event.id}\n"
      ics_string << "DTSTAMP:#{Time.now.strftime("%Y%m%dT%H%M%SZ")}\n"
      ics_string << "DTSTART:#{start_time.strftime("%Y%m%dT%H%M%SZ")}\n"
      ics_string << "DTEND:#{end_time.strftime("%Y%m%dT%H%M%SZ")}\n"
      ics_string << "SUMMARY:#{event.name} - #{role}\n"
      ics_string << "DESCRIPTION:#{event.description}\n"
      ics_string << "LOCATION:#{event.location}, #{event.city}\n"
      ics_string << "END:VEVENT\n"
    end
    ics_string << "END:VCALENDAR"
  end

  private

  def self.format_time(date, time)
    new_time = ""

    new_date = date.strftime('%d-%m-%Y')
    if 24 - time.slice(0..1).to_i > 12
      new_time = new_date + " " + time + ":00 PM"
    else
      new_time = new_date + " " + time + ":00 AM"
    end
    DateTime.strptime(new_time, '%d-%m-%Y %I:%M:%S %p')
  end

end