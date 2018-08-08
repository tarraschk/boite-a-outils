class AddContactMailingListToPeople < ActiveRecord::Migration
  def change
    add_column :people, :contact_mailing_list, :string
  end
end
