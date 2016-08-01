class FixType < ActiveRecord::Migration
  def change
    rename_column :comites, :type, :typecomite
  end
end
