class RemoveCountryCodeFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :country_code, :string
  end
end
