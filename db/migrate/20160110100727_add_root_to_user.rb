class AddRootToUser < ActiveRecord::Migration
  def change
    add_column :users, :root, :boolean
  end
end
