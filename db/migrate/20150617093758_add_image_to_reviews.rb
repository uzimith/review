class AddImageToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :image, :binary, limit: 10 * 1024 * 1024 # megabytes
    add_column :reviews, :image_name, :string
    add_column :reviews, :image_content_type, :string
  end
end
