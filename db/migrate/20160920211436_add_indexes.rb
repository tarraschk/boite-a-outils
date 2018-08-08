class AddIndexes < ActiveRecord::Migration
  def change
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    add_index :addresses, :zip
    execute ('CREATE  INDEX  "index_people_on_tags" ON "people" USING gin ("tags" gin_trgm_ops)')
  end
end
