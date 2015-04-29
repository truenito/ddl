class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :steam_id
      t.string :name
      t.string :status, :default => 'unvouched'
      t.integer :rating, :default => 3500
      t.integer :win_count, :default => 0
      t.integer :lose_count, :default => 0
      t.integer :leave_count, :default => 0
      t.integer :team_id
      t.integer :match_id

      t.timestamps null: false
    end
  end
end
