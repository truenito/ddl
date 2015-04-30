class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text, default: 'Usuario sin descripción.'
  end
end