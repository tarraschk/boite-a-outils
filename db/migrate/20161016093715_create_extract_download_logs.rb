class CreateExtractDownloadLogs < ActiveRecord::Migration
  def change
    create_table :extract_download_logs do |t|
      t.integer :user_id
      t.integer :export_type

      t.timestamps null: false
    end
  end
end
