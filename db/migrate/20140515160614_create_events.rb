class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :date
      t.text :description
      t.string :location
      t.integer :capacity
      t.string :category
      t.timestamps
    end
  end
end


