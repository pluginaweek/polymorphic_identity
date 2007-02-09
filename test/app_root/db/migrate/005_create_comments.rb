class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :commentable_id,   :integer
      t.column :commentable_type, :string
      t.column :commenter_id,     :string
      t.column :commenter_type,   :string
    end
  end
  
  def self.down
    drop_table :comments
  end
end