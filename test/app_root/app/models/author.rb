class Author < ActiveRecord::Base
  has_many  :articles
  has_many  :pages
  has_many  :comments, :as => :commenter
end
