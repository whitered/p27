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

  end

end
