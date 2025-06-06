class CreateCharacterItems < ActiveRecord::Migration[8.0]
  def change
    create_table :character_items do |t|
      t.integer :character_id
      t.integer :item_id
      t.string :equipped_slot
      t.integer :position

      t.timestamps

      t.index :character_id
      t.index :item_id
    end
  end
end
