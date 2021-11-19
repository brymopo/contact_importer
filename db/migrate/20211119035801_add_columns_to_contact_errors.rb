class AddColumnsToContactErrors < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_errors, :name, :string, array: true, default: []
    add_column :contact_errors, :address, :string, array: true, default: []
    add_column :contact_errors, :email, :string, array: true, default: []
    add_column :contact_errors, :phone, :string, array: true, default: []
    add_column :contact_errors, :date_of_birth, :string, array: true, default: []
    add_column :contact_errors, :credit_card, :string, array: true, default: []
    add_column :contact_errors, :user_errors, :string, array: true, default: []
  end
end
