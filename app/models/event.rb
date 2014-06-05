require 'carrierwave/orm/activerecord'

class Event < ActiveRecord::Base

  mount_uploader :event_pic, EventPictureUploader

  belongs_to :user
  has_many :registrations
  has_many :users, through: :registrations

  def self.search(query)
    where("city iLIKE ?", "%#{query}%")
  end


  def tickets_remaining
    self.capacity - number_of_registrations
  end

  def number_of_registrations
    self.registrations.where(role: Registration.roles[:guest]).size
  end

end