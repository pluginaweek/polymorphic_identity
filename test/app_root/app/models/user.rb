class User < ActiveRecord::Base
  has_many  :comments, :as => :commenter
end
