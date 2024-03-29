require 'spec_helper'

describe Group do

  let(:group) { Group.make }

  describe 'blueprint' do

    it 'should make valid group' do
      group.should be_valid
    end

  end

  it 'should have name' do
    group.should respond_to(:name)
  end

  describe 'name' do
    it 'should return group id if no name was defined' do
      g = Group.make!(:name => nil)
      g.name.should == g.id.to_s
    end
  end

  it 'should have users' do
    group.should respond_to(:users)
  end


  it 'should have set_admin_status method' do
    group.should respond_to(:set_admin_status)
  end

  describe 'set_admin_status' do

    before do
      @group = Group.make!
      @member, @admin, @outsider = User.make!(3)
      @group.users << @member << @admin
      @group.memberships.find_by_user_id(@admin.id).update_attribute(:is_admin, true)
    end

    it 'should turn regular user to admin' do
      @group.set_admin_status @member, true
      @group.memberships.find_by_user_id(@member.id).is_admin?.should be_true
    end

    it 'should turn admin to regular user' do
      @group.set_admin_status @admin, false
      @group.memberships.find_by_user_id(@admin.id).is_admin?.should be_false
    end

    it 'should not raise exception if user is not a member of the group' do
      lambda {
        @group.set_admin_status @outsider, false
      }.should_not raise_exception
    end

    it 'should do nothing if user is not a member of the group' do
      lambda {
        @group.set_admin_status @outsider, true
      }.should_not change(@group.memberships, :count)
    end

  end

  it 'should have user_is_admin? method' do
    group.should respond_to(:user_is_admin?)
  end

  describe 'user_is_admin?' do

    before do
      @group = Group.make!
      @member, @admin, @outsider = User.make!(3)
      @group.users << @member << @admin
      @group.memberships.find_by_user_id(@admin.id).update_attribute(:is_admin, true)
   end

    it 'should return true if user is admin' do
      @group.user_is_admin?(@admin).should be_true
    end

    it 'should return false if user is regular admin' do
      @group.user_is_admin?(@member).should be_false
    end

    it 'should return false if user is not a member of the group' do
      @group.user_is_admin?(@outsider).should be_false
    end

    it 'should return false if user is nil' do
      @group.user_is_admin?(nil).should be_false
    end

  end

  it 'should have owner' do
    group.should respond_to(:owner)
  end

  it 'should have private? property' do
    group.should respond_to(:private?)
  end

  describe 'private?' do
    
    it 'should not be nil' do
      group = Group.new(:private => nil)
      group.should_not be_valid
      group.errors[:private].should_not be_empty
    end

    it 'should be false by default' do
      Group.new.private?.should be_false
    end

  end
  
  it 'should have public? property' do
    group.should respond_to(:public?)
  end

  describe 'public?' do

    it 'should be true for not private groups' do
      group = Group.new(:private => false)
      group.public?.should be_true
    end

    it 'should be false for private groups' do
      group = Group.new(:private => true)
      group.public?.should be_false
    end

  end


  it 'should have hospitable? property' do
    group.should respond_to(:hospitable?)
  end

  describe 'hospitable?' do

    it 'should not be nil' do
      group = Group.new(:hospitable => nil)
      group.should_not be_valid
      group.errors[:hospitable].should_not be_empty
    end

    it 'should be true by default' do
      Group.new.hospitable?.should be_true
    end

  end

  it 'should have posts' do
    group.should respond_to(:posts)
  end

  it 'should have user_can_post? method' do
    group.should respond_to(:user_can_post?)
  end

  describe 'user_can_post?' do

    it 'should be true for group admin' do
      admin = User.make!
      group.users << admin
      group.set_admin_status admin, true
      group.user_can_post?(admin).should be_true
    end

    it 'should be true for group owner' do
      owner = User.make!
      group.owner = owner
      group.user_can_post?(owner).should be_true
    end

    it 'should be true for group member' do
      member = User.make!
      group.users << member
      group.user_can_post?(member).should be_true
    end

    it 'should be false for outsider' do
      outsider = User.make!
      group.user_can_post?(outsider).should be_false
    end

    it 'should be false for nil' do
      group.user_can_post?(nil).should be_false
    end

  end

  it 'should have user_can_announce_game? method' do
    group.should respond_to(:user_can_announce_game?)
  end

  describe 'user_can_announce_game?' do

    it 'should be false for nil' do
      group.user_can_announce_game?(nil).should be_false
    end

    it 'should be false for outsider' do
      group.user_can_announce_game?(User.make!).should be_false
    end

    it 'should be true for group admin' do
      admin = User.make!
      admin.groups << group
      group.set_admin_status admin, true
      group.user_can_announce_game?(admin).should be_true
    end
  end

  it 'should have games' do
    group.should respond_to(:games)
  end

  it 'should have user_can_view? method' do
    group.should respond_to(:user_can_view?)
  end

  describe 'user_can_view?' do

    before do
      @group = Group.make!
      @insider, @outsider = User.make!(2)
      @group.users << @insider
    end

    context 'for private group' do

      before do
        @group.update_attribute(:private, true)
      end

      it 'should be false if user is outsider' do
        @group.user_can_view?(@outsider).should be_false
      end

      it 'should be true if user is insider' do
        @group.user_can_view?(@insider).should be_true
      end

      it 'should be false if user is nil' do
        @group.user_can_view?(nil).should be_false
      end

    end

    context 'for public group' do

      before do
        @group.update_attribute(:private, false)
      end

      it 'should be true if user is outsider' do
        @group.user_can_view?(@outsider).should be_true
      end

      it 'should be true if user is insider' do
        @group.user_can_view?(@insider).should be_true
      end

      it 'should be true if user is nil' do
        @group.user_can_view?(nil).should be_true
      end

    end

  end

  it 'should have add_user method' do
    Group.new.should respond_to(:add_user)
  end

  describe 'add_user' do

    before do
      @group = Group.make!
      @user = User.make!
    end

    it 'should add new user' do
      @group.add_user @user
      @group.users.should include(@user)
    end

    it 'should not add user twice' do
      @group.users << @user
      @group.add_user @user
      @group.reload
      @group.users.count.should == 1
    end
  end
end
