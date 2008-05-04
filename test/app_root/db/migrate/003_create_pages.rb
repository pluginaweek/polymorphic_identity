class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.integer :author_id
      t.text :content
    end
  end
  
  def self.down
    drop_table :pages
  end
end
