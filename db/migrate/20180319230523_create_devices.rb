class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.references :player, foreign_key: true
      t.string :token
      t.datetime :registered_at

      t.timestamps
    end
  end
end
