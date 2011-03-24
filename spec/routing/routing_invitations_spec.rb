require 'spec_helper'

describe InvitationsController do

  context 'inside group' do

    it 'should route new' do
      { :get => '/groups/8/invitations/new' }.should route_to(:controller => 'invitations',
                                                              :action => 'new',
                                                              :group_id => '8')
    end

    it 'should route create' do
      { :post => '/groups/9/invitations' }.should route_to(:controller => 'invitations',
                                                           :action => 'create',
                                                           :group_id => '9')
    end

    it 'should route index' do
      { :get => '/invitations' }.should route_to(:controller => 'invitations',
                                                 :action => 'index')
    end

    it 'should route accept' do
      { :post => '/invitations/9/accept' }.should route_to(:controller => 'invitations',
                                                           :action => 'accept',
                                                           :id => '9')
    end

    it 'should route decline' do
      { :post => '/invitations/5/decline' }.should route_to(:controller => 'invitations',
                                                            :action => 'decline',
                                                            :id => '5')
    end

  end

end
