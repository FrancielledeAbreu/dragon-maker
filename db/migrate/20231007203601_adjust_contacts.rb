class AdjustContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :cep

    change_column_null :contacts, :address_id, false
  end
end
