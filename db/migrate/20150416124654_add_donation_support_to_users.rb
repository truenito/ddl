class AddDonationSupportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :donator, :boolean
    add_column :users, :donation_count, :integer, default: false
  end
end
