class CreateUserToPersonRelations < ActiveRecord::Migration
  def change
    create_table :user_to_person_relations do |t|
      t.integer :user_id
      t.integer :person_id

      t.timestamps null: false
    end
    add_index :user_to_person_relations, :user_id
    add_index :user_to_person_relations, :person_id
  end
end
