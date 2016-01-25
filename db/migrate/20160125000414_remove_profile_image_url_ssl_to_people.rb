class RemoveProfileImageUrlSslToPeople < ActiveRecord::Migration
  def change
    remove_column :people, :profile_image_url_ssl, :string
  end
end
