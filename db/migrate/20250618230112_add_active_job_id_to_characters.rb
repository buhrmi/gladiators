class AddActiveJobIdToCharacters < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :active_job_id, :string
    remove_column :characters, :activity

    add_index :characters, :active_job_id
  end
end
