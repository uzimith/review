class AddFavorite < ActiveRecord::Migration
  def change
     create_table :favorites do |t|
       t.references :user
       t.references :review
     end
  end
end
