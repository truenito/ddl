class AddFrozenUsersToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :users_and_stats, :hstore, array: true
  end
end
