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

  it 'should route index' do
    { :get => '/groups' }.should route_to(:controller => 'groups',
                                          :action => 'index')
  end

  it 'should route edit' do
    { :get => '/groups/1/edit' }.should route_to(:controller => 'groups',
                                                :action => 'edit',
                                                :id => '1')
  end

  it 'should route update' do
    { :put => '/groups/1' }.should route_to(:controller => 'groups',
                                           :action => 'update',
                                           :id => '1')
  end

  it 'should route my_groups' do
    { :get => '/my_groups' }.should route_to(:controller => 'groups',
                                             :action => 'my_groups')
  end

end

