class AddMandatToPerson < ActiveRecord::Migration
  def change
    add_column :people, :mandat, :string
  end
end
