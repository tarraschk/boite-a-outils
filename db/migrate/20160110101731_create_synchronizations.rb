class CreateSynchronizations < ActiveRecord::Migration
  def change
    create_table :synchronizations do |t|
      t.string :event

      t.timestamps null: false
    end
  end
end
