class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :race
      t.integer :exp
      t.integer :coppers, default: 0
      t.integer :level, default: 1
      t.integer :last_hp
      t.integer :last_hp_updated_at
      t.integer :user_id

      t.timestamps
    end
  end
end
