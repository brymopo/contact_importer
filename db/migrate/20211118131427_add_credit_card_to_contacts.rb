class AddCreditCardToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :credit_card, :binary
    add_column :contacts, :credit_card_key, :binary
    add_column :contacts, :credit_card_iv, :binary
  end
end
