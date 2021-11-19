class AddAasmStateToCsvFiles < ActiveRecord::Migration[6.1]
  def change
    add_column :csv_files, :aasm_state, :string
  end
end
