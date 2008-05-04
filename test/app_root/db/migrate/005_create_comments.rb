class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.string :commenter_id
      t.string :commenter_type
    end
  end
  
  def self.down
    drop_table :comments
  end
end
