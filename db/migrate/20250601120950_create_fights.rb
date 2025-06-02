class CreateFights < ActiveRecord::Migration[8.0]
  def change
    create_table :fights do |t|
      t.integer :attacker_id
      t.integer :target_id
      t.string :target_type
      t.boolean :won
      t.json :logs, default: []
      t.json :metadata, default: {}

      t.timestamps
    end
  end
end
