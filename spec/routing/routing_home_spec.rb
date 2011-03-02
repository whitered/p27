require 'spec_helper'

describe HomeController do

  it 'should route index' do
    { :get => '/' }.should route_to( :controller => 'home', :action => 'index' )
  end
  
end

