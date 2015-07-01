class AddImageToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :image_url, :string
  end
end
