class CreatePlayerArenas < ActiveRecord::Migration[5.1]
  def change
    create_table :player_arenas do |t|
      t.references :player, foreign_key: true
      t.references :arena, foreign_key: true
      t.datetime :joined_at

      t.timestamps
    end
  end
end
