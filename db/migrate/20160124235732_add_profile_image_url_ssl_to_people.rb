class AddProfileImageUrlSslToPeople < ActiveRecord::Migration
  def change
    add_column :people, :profile_image_url_ssl, :string
  end
end
