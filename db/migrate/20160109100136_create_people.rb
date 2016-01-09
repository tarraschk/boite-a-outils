class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :people_id
      t.references :parent, index: true
      t.references :recruiter, index: true
      t.references :user, index: true
      t.string :email

      t.timestamps null: false
    end
    add_index :people, :people_id
  end
end
