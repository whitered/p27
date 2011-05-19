require 'spec_helper'

describe 'invitations/index.html.haml' do

  before do 
    stub_template 'invitations/_invitation' => "<div class='stubbed_template'>invitations/invitation.html.haml</div>"
  end

  let(:page) { Capybara.string rendered }

  context 'with some invitations given' do

    before do
      @user = User.make!
      @invitations = Array.new(3) { Invitation.make!(:group => Group.make!, :user => @user, :inviter => User.make!) }
      render
    end

    it 'should render template :invitation for each invitation' do
      page.all('.stubbed_template').size.should eq(3)
    end

  end

  it 'should have dummy text if no invitations present' do
    @invitations = []
    render
    page.should have_content(t('invitations.index.none'))
  end

end
