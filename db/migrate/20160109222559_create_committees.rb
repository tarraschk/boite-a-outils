class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
      t.integer :event_id, index: true
      t.string :slug
      t.string :animator_email, index: true

      t.timestamps null: false
    end
  end
end
