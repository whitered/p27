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

end

