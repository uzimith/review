class AddUserToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :user_id, :reference
  end
end
