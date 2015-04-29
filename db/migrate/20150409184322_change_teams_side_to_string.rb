class ChangeTeamsSideToString < ActiveRecord::Migration
  def change
    change_column :teams, :side, :string
  end
end
