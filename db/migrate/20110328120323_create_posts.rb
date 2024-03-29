class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :author_id
      t.integer :group_id

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
