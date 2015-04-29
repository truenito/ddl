class CreateMatchTokens < ActiveRecord::Migration
  def change
    create_table :match_tokens do |t|
      t.integer :match_id
      t.integer :user_id
      t.boolean :result
      t.boolean :captain
      t.leaver :boolean, default: false

      t.timestamps null: false
    end
  end
end
