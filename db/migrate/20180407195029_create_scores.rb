class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.references :arena, foreign_key: true
      t.references :player, foreign_key: true
      t.integer :points
      t.datetime :scored_at

      t.timestamps
    end
  end
end
