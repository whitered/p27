require 'spec_helper'

describe GamesController do

  it 'should route show' do
    { :get => '/games/3' }.should route_to(:controller => 'games',
                                           :action => 'show',
                                           :id => '3')
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

  end
end
