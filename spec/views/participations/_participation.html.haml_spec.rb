require 'spec_helper'

describe 'participations/_participation.html.haml' do

  before do
    stub_template 'users/_user.html.haml' => '%div[user]'
    game = Game.make!(:announcer => User.make!, :group => Group.make!)
    @participation = Participation.make(:user => User.make!, 
                                         :game => game,
                                         :rebuys => 12,
                                         :addon => true,
                                         :win => 1200)
  end

  let(:page) { Capybara.string rendered }

  def do_render
    render :partial => 'participations/participation', :locals => { :participation => @participation }
  end

  it 'should render user' do
    do_render
    page.should render_template('users/_user')
  end

  it 'should render dummy_name if user is nil' do
    @participation.user = nil
    @participation.dummy_name = 'Dummy_name'
    do_render
    page.should have_content('Dummy_name')
    page.should_not render_template('users/_user')
  end

  it 'should render rebuys' do
    do_render
    page.should have_content(@participation.rebuys.to_s)
  end

  it 'should render addon' do
    do_render
    page.should have_content(@participation.addon? ? '1' : '0')
  end

  it 'should render win' do
    do_render
    page.should have_content(@participation.win.to_s)
  end
end
