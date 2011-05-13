require 'spec_helper'

describe MembershipsController do

  it 'should route destroy' do
    { :delete => '/memberships/34' }.should route_to(:controller => 'memberships',
                                                     :action => 'destroy',
                                                     :id => '34')
  end

  it 'should route update' do
    { :put => '/memberships/4' }.should route_to(:controller => 'memberships',
                                                 :action => 'update',
                                                 :id => '4')
  end

  context 'inside group' do

    it 'should route create' do
      { :post => '/groups/2/memberships' }.should route_to(:controller => 'memberships',
                                                           :action => 'create',
                                                           :group_id => '2')
    end

  end
end
