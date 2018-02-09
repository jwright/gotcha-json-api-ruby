class AddAPIKeyToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :api_key, :string
  end
end
