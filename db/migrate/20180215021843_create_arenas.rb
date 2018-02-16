class CreateArenas < ActiveRecord::Migration[5.1]
  def change
    create_table :arenas do |t|
      t.string :location_name
      t.string :street_address1
      t.string :street_address2
      t.string :city
      t.string :state
      t.string :zip_code
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
