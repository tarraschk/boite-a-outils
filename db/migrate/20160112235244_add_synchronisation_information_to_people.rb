class AddSynchronisationInformationToPeople < ActiveRecord::Migration
  def change
    add_column :people, :contacted, :boolean
    add_column :people, :updated_from_nb, :boolean
  end
end
