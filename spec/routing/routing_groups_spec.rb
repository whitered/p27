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

  it 'should route manage_members' do
    { :post => '/groups/3/manage_members' }.should route_to(:controller => 'groups',
                                                          :action => 'manage_members',
                                                          :id => '3')
  end

  it 'should route manage_admins' do
    { :post => '/groups/3/manage_admins' }.should route_to(:controller => 'groups',
                                                           :action => 'manage_admins',
                                                           :id => '3')
  end

  it 'should route leave' do
    { :post => '/groups/1/leave' }.should route_to(:controller => 'groups',
                                                   :action => 'leave',
                                                   :id => '1')
  end

  it 'should route index' do
    { :get => '/groups' }.should route_to(:controller => 'groups',
                                          :action => 'index')
  end

  it 'should route join' do
    { :post => '/groups/5/join' }.should route_to(:controller => 'groups',
                                                  :action => 'join',
                                                  :id => '5')
  end

  it 'should route edit' do
    { :get => 'groups/1/edit' }.should route_to(:controller => 'groups',
                                                :action => 'edit',
                                                :id => '1')
  end

  it 'should route update' do
    { :put => 'groups/1' }.should route_to(:controller => 'groups',
                                           :action => 'update',
                                           :id => '1')
  end

end

