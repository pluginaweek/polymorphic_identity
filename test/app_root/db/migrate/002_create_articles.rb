class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :author_id,  :integer
      t.column :content,    :text
    end
  end
  
  def self.down
    drop_table :articles
  end
end