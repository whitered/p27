require 'spec_helper'

describe HomeController do

  describe 'index' do

    it 'should be successful' do
      get :index
      response.should be_successful
    end

    context 'for logged in user' do

      it 'should assign posts from user groups ordered by creation date' do
        groupA = Group.make!
        groupB = Group.make!
        groupC = Group.make!
        user = User.make!
        user.groups << groupA << groupC
        author = User.make!

        postA, postB, postC1, postC2 = [
          [groupA, 3],
          [groupB, 2],
          [groupC, 1],
          [groupC, 4]
        ].map do |group, days| 
          Post.make!(:author => author, :group => group, :created_at => days.days.ago)
        end

        #postA = Post.make!(:author => author, :group => groupA, :created_at => 3.days.ago)
        #postB = Post.make!(:author => author, :group => groupB, :created_at => 2.days.ago)
        #postC1 = Post.make!(:author => author, :group => groupC, :created_at => 1.day.ago)
        #postC2 = Post.make!(:author => author, :group => groupC, :created_at => 4.days.ago)
        sign_in user

        get :index

        assigns[:posts].should eq [postC1, postA, postC2]
      end
    end
  end

end
