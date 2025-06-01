class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :race
      t.integer :exp
      t.integer :last_hp
      t.integer :last_hp_updated_at

      t.timestamps
    end
  end
end
