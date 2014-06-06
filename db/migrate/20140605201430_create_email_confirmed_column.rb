class CreateEmailConfirmedColumn < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmed, :boolean, default: false
  end
end
