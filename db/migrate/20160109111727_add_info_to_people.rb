class AddInfoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :phone_number, :string
    add_column :people, :first_name, :string
    add_column :people, :last_name, :string
  end
end
