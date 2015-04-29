class AddFbCallbackColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :real_name, :string
    add_column :users, :real_middle_name, :string
    add_column :users, :real_last_name, :string
    add_column :users, :gender, :string
    add_column :users, :timezone, :integer
    add_column :users, :facebook_link, :string
  end
end
