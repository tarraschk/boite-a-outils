class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.integer :event_id
      t.string :slug
      t.string :animator_email

      t.timestamps null: false
    end
    add_index :event_id
    add_index :animator_email
  end
end
