class AddLastFourToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :last_four, :string
  end
end
