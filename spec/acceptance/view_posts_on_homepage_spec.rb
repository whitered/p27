require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'View Posts On Homepage' do

  background do
    @user = User.make!
    @groupA, @groupB, @groupC = Group.make!(3)
    author = User.make!
    @postA = Post.make!(:author => author, :group => @groupA)
    @postB1, @postB2 = Post.make!(2, :author => author, :group => @groupB) 
    @postC = Post.make!(:author => author, :group => @groupC)
    @user.groups << @groupA << @groupB
  end

  scenario 'view posts' do
    login @user
    visit root_path
    page.should have_link(@postA.title, :href => post_path(@postA))
    page.should have_link(@postB1.title, :href => post_path(@postB1))
    page.should have_link(@postB2.title, :href => post_path(@postB2))
    page.should have_no_link(@postC.title)
  end

end
