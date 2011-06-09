class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :visitable, :polymorphic => true

  validates_presence_of :user_id
  validates_uniqueness_of :user_id, :scope => [:visitable_id, :visitable_type]
  validates_presence_of :visitable_id

  def existing_comments
    self[:existing_comments] || 0
  end
end
