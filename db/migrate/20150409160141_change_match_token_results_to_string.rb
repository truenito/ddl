class ChangeMatchTokenResultsToString < ActiveRecord::Migration
  def change
    change_column :match_tokens, :result, :string
  end
end
