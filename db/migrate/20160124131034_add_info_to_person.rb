class AddInfoToPerson < ActiveRecord::Migration
  def change
    add_column :people, :support_level, :integer
    add_column :people, :tags, :string
  end
end
