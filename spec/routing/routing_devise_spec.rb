require 'spec_helper'

describe Devise::RegistrationsController do

  it 'should route new' do
    { :get => '/registration' }.should route_to(:controller => 'registrations', 
                                                :action => 'new' )
  end

  it 'should route create' do
    { :post => '/registration' }.should route_to(:controller => 'registrations',
                                                 :action => 'create' )
  end

  it 'should route edit' do
    { :get => '/profile' }.should route_to(:controller => 'registrations',
                                           :action => 'edit')
  end

  it 'should route update' do
    { :put => '/registration' }.should route_to(:controller => 'registrations',
                                                :action => 'update')
  end

end


describe Devise::SessionsController do

  it 'should route new' do
    { :get => '/login' }.should route_to(:controller => 'devise/sessions', 
                                         :action => 'new' )
  end

  it 'should route create' do
    { :post => '/login' }.should route_to(:controller => 'devise/sessions',
                                          :action => 'create' )
  end

  it 'should route destroy' do
    { :get => '/logout' }.should route_to(:controller => 'devise/sessions', 
                                          :action => 'destroy' )
  end

end
