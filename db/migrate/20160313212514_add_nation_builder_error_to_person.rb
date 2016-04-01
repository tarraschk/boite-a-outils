class AddNationBuilderErrorToPerson < ActiveRecord::Migration
  def change
    add_column :people, :nation_builder_error, :string
  end
end
