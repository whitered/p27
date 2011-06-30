require 'spec_helper'

describe 'registrations/new' do

  let(:user) { stub_model(User).as_new_record }

  before(:each) do
    assign(:user, user)
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
  end

  let(:page) { Capybara.string rendered }

  it 'should contain email field if no invitation is given' do
    render
    page.should have_field(t('activerecord.attributes.user.email'))
  end

  it 'should not contain email if invitation is given' do
    @invitation = Invitation.create!(:group => Group.make!, :inviter => User.make!, :email => user.email)
    render
    page.should have_no_field(t('activerecord.attributes.user.email'))
  end

  it 'should contain username field' do
    render
    page.should have_field(t('activerecord.attributes.user.username'))
  end

  it 'should contain password field' do
    render
    page.should have_field(t('activerecord.attributes.user.password'))
  end

  it 'should contain password confirmation field' do
    render
    page.should have_field(t('activerecord.attributes.user.password_confirmation'))
  end

  it 'should contain submit button' do
    render
    page.should have_button(t('registrations.new.submit'))
  end

  it 'should render error for wrong email' do
    user.errors.add(:email)
    render
    page.should have_content(t_error(User, :email))
  end

  it 'should render error for wrong username' do
    user.errors.add(:username)
    render
    page.should have_content(t_error(User, :username))
  end

  it 'should render error for wrong password' do
    user.errors.add(:password)
    render
    page.should have_content(t_error(User, :password))
  end

  it 'should have hidden invitation field if invitation was specified' do
    @invitation = Invitation.make!(:email => Faker::Internet.email,
                                   :group => Group.make!,
                                   :inviter => User.make!)
    render
    page.should have_field(:invitation, :hidden => true, :value => @invitation.code)
  end


end
