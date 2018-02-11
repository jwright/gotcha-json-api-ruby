class RemoveNameFieldsFromPlayers < ActiveRecord::Migration[5.1]
  def change
    Player.find_each do |player|
      player.name = "#{player.first_name} #{player.last_name}"
      player.save
    end

    remove_column :players, :first_name, :string
    remove_column :players, :last_name, :string
  end
end
