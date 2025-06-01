class CreateIdentities < ActiveRecord::Migration[7.1]
  def change
    create_table :identities do |t|
      t.string :provider
      t.string :provider_id
      t.json :provider_info
      t.integer :user_id

      t.timestamps
    end

    add_index :identities, :provider
    add_index :identities, :provider_id
    add_index :identities, :user_id
  end
end
