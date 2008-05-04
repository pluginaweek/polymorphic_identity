class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :author_id
      t.text :content
    end
  end
  
  def self.down
    drop_table :articles
  end
end
