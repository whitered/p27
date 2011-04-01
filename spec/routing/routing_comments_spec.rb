require 'spec_helper'

describe CommentsController do

  context 'in post' do

    it 'should route create' do
      { :post => '/posts/32/comments' }.should route_to(:controller => 'comments',
                                                            :action => 'create',
                                                            :post_id => '32')
    end
  end

end
