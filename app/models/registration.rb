class Registration < ActiveRecord::Base
  enum role: [ :creator, :admin, :guest, :waitlist ]
  belongs_to :event
  belongs_to :user
end
