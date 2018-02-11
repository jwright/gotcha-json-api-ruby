class AddNameToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :name, :string
  end
end
