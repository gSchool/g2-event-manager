class RenameAttendanceToRegistration < ActiveRecord::Migration
  def change
    rename_table :attendances, :registrations
  end
end