class ChangePhoneNumberToMobileInPerson < ActiveRecord::Migration
  def change
    rename_column :people, :phone_number, :mobile
  end
end
