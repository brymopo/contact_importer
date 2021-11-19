class CreateContactErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_errors do |t|
      t.string :contact_identifier, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
