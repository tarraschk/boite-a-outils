class CreateComites < ActiveRecord::Migration
  def change
    create_table :comites do |t|
      t.integer :number
      t.integer :type
      t.string :slug
      t.string :title
      t.string :desc1
      t.string :desc2
      t.string :coordinates
      t.boolean :active

      t.timestamps null: false
    end
  end
end
