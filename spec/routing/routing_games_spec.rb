require 'spec_helper'

describe GamesController do

  it 'should route show' do
    { :get => '/games/3' }.should route_to(:controller => 'games',
                                           :action => 'show',
                                           :id => '3')
  end

  it 'should route join' do
    { :post => '/games/5/join' }.should route_to(:controller => 'games',
                                                 :action => 'join',
                                                 :id => '5')
  end

  it 'should route leave' do
    { :post => '/games/5/join' }.should route_to(:controller => 'games',
                                                 :action => 'join',
                                                 :id => '5')
  end

  it 'should route edit' do
    { :get => '/games/4/edit' }.should route_to(:controller => 'games',
                                                :action => 'edit',
                                                :id => '4')
  end

  it 'should route update' do
    { :put => '/games/5' }.should route_to(:controller => 'games',
                                           :action => 'update',
                                           :id => '5')
  end

  it 'should route index' do
    { :get => '/games' }.should route_to(:controller => 'games',
                                         :action => 'index')
  end

  context 'in group' do

    it 'should route new' do
      { :get => '/groups/43/games/new' }.should route_to(:controller => 'games',
                                                         :action => 'new',
                                                         :group_id => '43')
    end

    it 'should route create' do
      { :post => '/groups/4/games' }.should route_to(:controller => 'games',
                                                     :action => 'create',
                                                     :group_id => '4')
    end

    it 'should route games' do
      { :get => '/groups/3/games' }.should route_to(:controller => 'games',
                                                    :action => 'index',
                                                    :group_id => '3')
    end

    it 'should route archive' do
      { :get => '/groups/4/archive' }.should route_to(:controller => 'games',
                                                      :action => 'archive',
                                                      :group_id => '4')
    end

  end
end
