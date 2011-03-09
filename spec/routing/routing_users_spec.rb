require 'spec_helper'

describe UsersController do

  it 'should route show' do
    { :get => '/users/ivan' }.should route_to(:controller => 'users',
                                              :action => 'show',
                                              :id => 'ivan')
  end

end
