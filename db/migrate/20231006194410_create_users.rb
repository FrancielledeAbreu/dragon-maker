class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :cpf
      t.string :phone
      t.string :street_number
      t.string :complement
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
