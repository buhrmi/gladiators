class AddAttrsToDeposits < ActiveRecord::Migration[8.0]
  def change
    add_column :deposits, :wallet_id, :integer
    add_column :deposits, :script_pubkey, :string
    add_column :deposits, :vout_index, :string
  end
end
