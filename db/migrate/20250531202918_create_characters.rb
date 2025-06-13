class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :race, default: "human"
      t.integer :exp, default: 0
      t.integer :guild_id
      t.integer :coppers, default: 0
      t.integer :level, default: 1
      t.integer :last_hp, default: 100
      t.integer :last_hp_updated_at, default: 0
      t.string :discord_user_id

      t.string :email
      t.string :battle_cry
      t.string :victory_cry

      t.timestamps
    end
  end
end
