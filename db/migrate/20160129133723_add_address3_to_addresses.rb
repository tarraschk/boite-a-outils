class AddAddress3ToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address3, :string
  end
end
