require 'spec_helper'

describe PostsController do

  it 'should route show' do
    { :get => '/posts/3' }.should route_to(:controller => 'posts',
                                           :action => 'show',
                                           :id => '3')
  end

  it 'should route edit' do
    { :get => '/posts/6/edit' }.should route_to(:controller => 'posts',
                                                :action => 'edit',
                                                :id => '6')
  end

  it 'should route update' do
    { :put => 'posts/4' }.should route_to(:controller => 'posts',
                                          :action => 'update',
                                          :id => '4')
  end

  context 'in groups' do

    it 'should route new' do
      { :get => '/groups/4/posts/new' }.should route_to(:controller => 'posts',
                                                        :action => 'new',
                                                        :group_id => '4')
    end

    it 'should route create' do
      { :post => '/groups/1/posts' }.should route_to(:controller => 'posts',
                                                     :action => 'create',
                                                     :group_id => '1')
    end
  end
end
