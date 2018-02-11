class AddNameNotNullConstraintOnPlayers < ActiveRecord::Migration[5.1]
  def change
    change_column :players, :name, :string, null: false
  end
end
