class AddConfirmationCodeToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :confirmation_code, :string
  end
end
