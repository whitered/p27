class Post < ActiveRecord::Base

  belongs_to :author, :class_name => 'User'
  belongs_to :group

  validates_presence_of :author_id

end
