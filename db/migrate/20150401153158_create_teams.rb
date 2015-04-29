class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :captain_id
      t.boolean :side
      t.integer :match_id

      t.timestamps null: false
    end
  end
end
