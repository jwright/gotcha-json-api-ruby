class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address, null: false
      t.string :crypted_password, null: false
      t.string :salt, null: false
      t.string :avatar

      t.timestamps
    end
  end
end
