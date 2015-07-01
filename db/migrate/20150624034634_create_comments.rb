class CreateComments < ActiveRecord::Migration
  def change
     create_table :comments do |t|
       t.references :user
       t.references :review
       t.text :text
     end
  end
end
