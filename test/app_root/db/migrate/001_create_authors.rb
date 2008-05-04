class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
    end
  end
  
  def self.down
    drop_table :authors
  end
end
