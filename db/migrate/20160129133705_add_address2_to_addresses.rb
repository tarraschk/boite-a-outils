class AddAddress2ToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address2, :string
  end
end
