class Article < ActiveRecord::Base
  belongs_to  :author
  has_many    :comments, :as => :commentable
end
