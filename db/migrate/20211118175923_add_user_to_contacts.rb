class AddUserToContacts < ActiveRecord::Migration[6.1]
  def change
    add_reference :contacts, :user, null: false, foreign_key: true
    add_index :contacts, [:user_id, :email], unique: true
  end
end
