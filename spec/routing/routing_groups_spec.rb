require 'spec_helper'

describe GroupsController do

  it 'should route new' do
    { :get => '/groups/new' }.should route_to(:controller => 'groups', 
                                              :action => 'new')
  end

  it 'should route create' do
    { :post => '/groups' }.should route_to(:controller => 'groups',
                                           :action => 'create')
  end

  it 'should route show' do
    { :get => '/groups/2' }.should route_to(:controller => 'groups',
                                            :action => 'show',
                                            :id => '2')
  end

end

