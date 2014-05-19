class Attendance < ActiveRecord::Base
  enum role: [ :creator, :admin, :guest ]
  belongs_to :event
  belongs_to :user
end
