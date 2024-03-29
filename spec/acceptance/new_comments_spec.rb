require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'New Comments' do

  background do
    @post = Post.make!(:author => User.make!, :group => Group.make!, :created_at => 1.day.ago)
    ['first comment', 'second comment'].each do |msg|
      comment = Comment.build_from(@post, User.make!.id, msg)
      comment.created_at = 1.hour.ago
      comment.save!
    end
    @user = User.make!
    login @user
  end

  scenario 'user see all comments as new at first post view' do
    visit post_path(@post)
    new_comments = page.all('.new.comment')
    new_comments.size.should eq(2)
    new_comments.any?{ |c| c.has_content?('first comment') }.should be_true
    new_comments.any?{ |c| c.has_content?('second comment') }.should be_true
  end


  scenario 'user sees new comments marked as new at second visit' do
    visit post_path(@post)
    new_comment = Comment.build_from(@post, User.make!.id, 'last comment')
    new_comment.save!
    visit post_path(@post)
    page.all('.new.comment').size.should eq(1)
    new_comments = page.all('.new.comment')
    new_comments.any?{ |c| c.has_content?('last comment') }.should be_true
    new_comments.any?{ |c| c.has_content?('first comment') }.should be_false
    new_comments.any?{ |c| c.has_content?('second comment') }.should be_false
  end

end
