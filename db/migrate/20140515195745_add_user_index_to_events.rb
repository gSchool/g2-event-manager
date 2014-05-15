class AddUserIndexToEvents < ActiveRecord::Migration
  def change
    add_column :events, :user_id, :string
    add_index :events, :user_id
  end
end
