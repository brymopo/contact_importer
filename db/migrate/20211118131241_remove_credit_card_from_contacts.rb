class RemoveCreditCardFromContacts < ActiveRecord::Migration[6.1]
  def change
    remove_column :contacts, :credit_card
  end
end
