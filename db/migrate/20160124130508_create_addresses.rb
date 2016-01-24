class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address1
      t.string :city
      t.string :country_code
      t.string :zip
      t.belongs_to :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
