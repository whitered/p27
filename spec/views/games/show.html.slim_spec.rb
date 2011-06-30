require 'spec_helper'

describe "games/show" do

  before do
    stub_template 'participations/_participation.html.slim' => 'div class="participation"'
    stub_template 'users/_user.html.slim' => 'div class="user" id="user_#{user.id}"'
    stub_template 'shared/_date.html.slim' => '= date.to_s'
    stub_template 'games/_game_type.html.slim' => 'div class="game_type"'
    @game = Game.make!(:announcer => User.make!, :group => Group.make!)
  end

  def content_for name
    Capybara.string view.instance_variable_get(:@_content_for)[name]
  end

  let(:page) { Capybara.string rendered }

  it 'should have #game selector' do
    render
    page.should have_selector('#game')
  end

  it 'should have game date' do
    render
    page.should have_content(@game.date.to_s)
  end

  it 'should have game description' do
    render
    page.should have_content(@game.description)
  end

  it 'should have game place' do
    render
    page.should have_content(@game.place)
  end

  describe 'title' do
    it 'should have link to group' do
      render
      content_for(:title_prefix).should have_link(@game.group.name, :href => group_path(@game.group))
    end
  end

  it 'should render game announcer' do
    render
    page.should have_selector('#user_' + @game.announcer.id.to_s)
  end

  it 'should render link to edit game if user authorized to' do
    @game.group.users << @game.announcer
    sign_in @game.announcer
    render
    page.should have_link(t('games.show.edit'), :href => edit_game_path(@game))
  end

  it 'should not render link to edit game for not authorized user' do
    render
    page.should have_no_link(t('games.show.edit'))
    page.should have_no_xpath(".//a[@href = '#{edit_game_path(@game)}']")
  end

  it 'should not render zero costs' do
    render
    game_block = page.find('#game')
    %w(buyin rebuy addon).each do |word|
      game_block.should have_no_content(t('activerecord.attributes.game.' + word))
    end
  end

  it 'should render game type' do
    render
    page.should render_template('games/_game_type')
  end

  it 'should render participations' do
    @game.players << User.make!(3)
    @game.update_attribute(:archived, true)
    render
    page.should render_template('participations/_participation')
    page.all('#game #players .participation').size.should == 3
  end

  it 'should mark archived game' do
    @game.update_attribute(:archived, true)
    render
    page.should have_content(t('games.show.archived'))
  end
end
