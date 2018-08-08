class AddNotesToPerson < ActiveRecord::Migration
  def change
    add_column :people, :notes, :text
  end
end
