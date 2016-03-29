class AddActivateToPeople < ActiveRecord::Migration
  def change
    add_column :people, :activated, :boolean, :default => true
  end
end
