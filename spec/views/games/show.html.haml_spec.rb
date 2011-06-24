require 'spec_helper'

describe "games/show.html.haml" do

  before do
    stub_template 'participations/_participation.html.haml' => '%div[participation]'
    stub_template 'users/_user.html.haml' => '%div[user]'
    stub_template 'shared/_date.html.haml' => '= date.to_s'
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

  it 'should render non-zero buyin' do
    @game.buyin = '120'
    render
    page.should have_xpath(".//span[@title='#{t('activerecord.attributes.game.buyin')}' and .='#{money @game.buyin}']")
  end

  it 'should render non-zero rebuy' do
    @game.buyin = '120'
    @game.rebuy = '220'
    render
    title = t('activerecord.attributes.game.rebuy')
    content = money(@game.rebuy)
    page.should have_xpath(".//span[@title='#{title}' and .='#{content}']")
  end

  it 'should render non-zero addon' do
    @game.buyin = '120'
    @game.rebuy = '220'
    @game.addon = '300'
    render
    title = t('activerecord.attributes.game.addon')
    content = money(@game.addon)
    page.should have_xpath(".//span[@title='#{title}' and .='#{content}']")
  end

  it 'should render game type' do
    @game.buyin = '100'
    render
    page.should have_content(t('activerecord.attributes.game.type.' + @game.game_type.to_s))
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
