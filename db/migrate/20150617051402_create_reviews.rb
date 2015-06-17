class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :caption
      t.text :body
      t.timestamps null: false
    end
  end
end
