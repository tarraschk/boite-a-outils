class AddInfoToCommittee < ActiveRecord::Migration
  def change
    add_column :committees, :people_id, :integer
    add_index :committees, :people_id
    add_column :committees, :name, :string
  end
end
