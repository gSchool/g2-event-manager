class AddStartAndEndTimeAsDate < ActiveRecord::Migration
  def up
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end

  def down
    remove_column :events, :start_time
    remove_column :events, :end_time
  end
end
