class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.references :seeker, index: true, foreign_key: { to_table: :players }
      t.references :opponent, index: true, foreign_key: { to_table: :players }
      t.datetime :matched_at
      t.references :arena, foreign_key: true
      t.datetime :found_at
      t.datetime :ignored_at

      t.timestamps
    end
  end
end
