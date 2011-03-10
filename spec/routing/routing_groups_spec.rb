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

  it 'should route add_user' do
    { :post => '/groups/4/add_user' }.should route_to(:controller => 'groups',
                                                      :action => 'add_user',
                                                      :id => '4')
  end

  it 'should route remove_user' do
    { :post => '/groups/4/remove_user' }.should route_to(:controller => 'groups',
                                                         :action => 'remove_user',
                                                         :id => '4')
  end

end

