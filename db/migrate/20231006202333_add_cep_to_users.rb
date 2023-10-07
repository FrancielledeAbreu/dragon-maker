class AddCepToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cep, :string
  end
end
