class AddEventPicToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_pic, :string
  end
end
