class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :cpf
      t.string :phone
      t.string :street_number
      t.string :complement
      t.string :latitude
      t.string :longitude
      t.string :cep
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
