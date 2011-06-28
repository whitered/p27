describe 'shared/_space' do

  it 'should be space' do
    render
    rendered.should == ' '
  end

end
