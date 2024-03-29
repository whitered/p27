require 'spec_helper'

describe Post do

  it 'should have title' do
    Post.new.should respond_to(:title)
  end

  it 'should have body' do
    Post.new.should respond_to(:body)
  end

  describe 'body' do

    before do
      @post = Post.make(:author => User.make!)
    end

    let(:post_body) { Capybara.string @post.body }

    it 'should substitute <br> in place of newlines' do
      @post.body = "first line\nsecond line"
      @post.save!
      @post.reload.body.should eq('first line<br>second line')
    end

    it 'should allow img tags' do
      @post.body = '<img src="some/image.jpg">'
      @post.save!
      @post.reload.body.should eq('<img src="some/image.jpg">')
    end

    it 'should allow links' do
      @post.body = '<a href="some/url">link</a>'
      @post.save!
      post_body.should have_link('link', :href => 'some/url')
    end

    it 'should allow i tag' do
      @post.body = '<i>italic</i>'
      @post.save!
      post_body.should have_selector('i', :text => 'italic')
    end

    it 'should allow b tag' do
      @post.body = '<b>bold</b>'
      @post.save!
      post_body.should have_selector('b', :text => 'bold')
    end

    it 'should close unclosed tags' do
      @post.body = '<b>bold'
      @post.save!
      @post.reload.body.should eq('<b>bold</b>')
    end

    it 'should not allow script tag' do
      @post.body = '<script>script</script>'
      @post.save!
      post_body.should have_no_selector('script')
    end

    it 'should not allow div tag' do
      @post.body = '<div>content</div>'
      @post.save!
      post_body.should have_no_selector('div')
    end
  end

  it 'should have author' do
    Post.new.should respond_to(:author)
  end

  describe 'author' do
    it 'should not be nil' do
      post = Post.new
      post.should be_invalid
      post.errors[:author_id].should_not be_empty
      post.author = User.make!
      post.should be_valid
    end
  end

  it 'should have group' do
    Post.new.should respond_to(:group)
  end

  it 'should have can_be_edited_by? method' do
    Post.new.should respond_to(:can_be_edited_by?)
  end

  describe 'can_be_edited_by?' do

    before do
      @post = Post.make!(:author => User.make!, :group => Group.make!(:owner => User.make!))
    end

    it 'should be false for nil' do
      @post.can_be_edited_by?(nil).should be_false
    end

    it 'should be false for outsider' do
      @post.can_be_edited_by?(User.make!).should be_false
    end

    it 'should be false for group member' do
      member = User.make!
      @post.group.users << member
      @post.can_be_edited_by?(member).should be_false
    end

    it 'should be true for group admin' do
      admin = User.make!
      @post.group.users << admin
      @post.group.set_admin_status admin, true
      @post.can_be_edited_by?(admin).should be_true
    end

    it 'should be true for group owner' do
      @post.can_be_edited_by?(@post.group.owner).should be_true
    end

    it 'should be true for post author' do
      @post.can_be_edited_by?(@post.author).should be_true
    end
  end

  it 'should have can_be_commented_by? method' do
    Post.new.should respond_to(:can_be_commented_by?)
  end

  describe 'can_be_commented_by?' do

    before do
      @post = Post.make!(:author => User.make!, :group => Group.make!(:owner => User.make!))
    end

    it 'should be false for nil' do
      @post.can_be_commented_by?(nil).should be_false
    end

    it 'should be false for outsider' do
      @post.can_be_commented_by?(User.make!).should be_false
    end

    it 'should be true for group member' do
      member = User.make!
      @post.group.users << member
      @post.can_be_commented_by?(member).should be_true
    end

    it 'should be true for group owner' do
      @post.can_be_commented_by?(@post.group.owner).should be_true
    end


    it 'should be false for post author if he is not a group member' do
      @post.can_be_commented_by?(@post.author).should be_false
      @post.group.users << @post.author
      @post.can_be_commented_by?(@post.author).should be_true
    end

  end

  it 'should have comment_threads' do
    Post.new.should respond_to(:comment_threads)
  end

  describe 'comment_threads' do

    before do
      user = User.make!
      @post = Post.make!(:author => user)
      3.times do 
        comment = Comment.build_from(@post, user.id, Faker::Lorem.sentence)
        comment.save!

        reply = Comment.build_from(@post, user.id, Faker::Lorem.sentence)
        reply.parent = comment
        reply.save!
      end
      @post.reload
    end

    it 'should contain all comments for the post' do
      @post.comment_threads.size.should eq(6)
    end

  end

  it 'should have root_comments' do
    Post.new.should respond_to(:root_comments)
  end

  it 'should have visits' do
    Post.new.should respond_to(:visits)
  end

  it 'should have method :new_comments_count_for' do
    Post.new.should respond_to(:new_comments_count_for)
  end

  describe 'new_comments_count_for' do

    before do
      @post = Post.make!(:author => User.make!)
      3.downto(1) do |n|
        comment = Comment.build_from(@post, @post.author.id, n.to_s + ' hours ago')
        comment.created_at = n.hours.ago
        comment.save!
      end
      @post.reload
      @user = User.make!
    end

    it 'should return nil for nil' do
      @post.new_comments_count_for(nil).should be_nil
    end

    it 'should return number of the comments if user has never viewed post' do
      @post.new_comments_count_for(@user).should eq(3)
    end

    it 'should return number of the new comments if user has viewed post earlier' do
      Visit.make!(:user => @user, :visitable => @post, :updated_at => 90.minutes.ago, :existing_comments => 2)
      @post.new_comments_count_for(@user).should eq(1)
    end
    
  end

  it 'should have update_visit method' do
    Post.new.should respond_to(:update_visit)
  end

  describe 'update_visit' do

    before do
      @post = Post.make!(:author => User.make!)
      @user = User.make!
    end

    context 'on first visit' do

      it 'should create new visit' do
        lambda do
          @post.update_visit(@user)
        end.should change(Visit, :count).by(1)
        visit = Visit.last
        visit.user.should == @user
      end

      it 'should return post creation time' do
        @post.update_visit(@user).should == @post.created_at
      end
    end

    context 'on secondary visit' do

      before do
        @last_time = 1.day.ago
        @user.visits.create(:visitable => @post, :created_at => @last_time, :updated_at => @last_time)
        @post.comment_threads.create!(:user => User.make!, :body => 'blablabla')
        @post.reload
      end

      it 'should update visit time' do
        lambda do
          @post.update_visit(@user)
        end.should change{ Visit.last.existing_comments }.from(0).to(1)
      end

      it 'should return previous visit update time' do
        @post.update_visit(@user).should == @last_time
      end
    end
  end

  it 'should have can_be_viewed_by? method' do
    Post.new.should respond_to(:can_be_viewed_by?)
  end

  describe 'can_be_viewed_by?' do

    before do
      @group = Group.make!(:private => true)
      @post = Post.make!(:group => @group, :author => User.make!)
      @post.stub(:group) { @group }
    end

    it 'should be true if user can view group' do
      @group.should_receive(:user_can_view?).and_return(true)
      @post.can_be_viewed_by?(nil).should == true
    end

    it 'should be false if user cannot view group' do
      @group.should_receive(:user_can_view?).and_return(false)
      @post.can_be_viewed_by?(nil).should == false
    end
  end
end
