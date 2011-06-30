require 'spec_helper'

describe ApplicationController do

  class FooController < ApplicationController
    def index
      render :text => 'foo'
    end
  end

  controller FooController

  before do
    Rails.application.routes.draw do
      resources :foo
    end
  end

  after do
    eval IO.read(File.join(Rails.root, 'config', 'routes.rb'))
  end

  context 'for logged in user' do

    before do
      @user = User.make!
      @user.groups << Group.make!(2)
      sign_in @user
    end

    it 'should assign :my_groups' do
      get :index
      assigns[:my_groups].should == @user.groups
    end
  end
end
