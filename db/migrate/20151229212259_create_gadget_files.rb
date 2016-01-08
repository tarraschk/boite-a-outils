class CreateGadgetFiles < ActiveRecord::Migration
  def change
    create_table :gadget_files do |t|
      t.string :url
      t.text :html

      t.timestamps null: false
    end
  end
end
