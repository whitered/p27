class AddCommentThreadsCountToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :comment_threads_count, :integer, :default => 0

    say_with_time 'Updating comments counters for posts' do
      Post.reset_column_information
      Post.find(:all).each do |p|
        Post.update_counters p.id, :comment_threads_count => p.comment_threads.count
      end
    end
  end

  def self.down
    remove_column :posts, :comment_threads_count
  end
end
