class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :display_name
      t.string :bio
      t.string :password_digest
      t.string :email, null: false
      t.string :default_currency, default: "BTC"
      t.string :email_verification_token
      t.boolean :email_verified, default: false, null: false
      t.boolean :hidden, default: false
      t.timestamp :last_login_at

      t.timestamps
      t.index :name, unique: true
      t.index :email
      t.index :hidden
    end
  end
end
