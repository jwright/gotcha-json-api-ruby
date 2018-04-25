class AddPendingAtToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :pending_at, :datetime
  end
end
