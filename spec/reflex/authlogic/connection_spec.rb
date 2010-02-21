require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Reflex::Authlogic::Connection do
  before(:each) do
    @connection = Reflex::Authlogic::Connection.new
  end
  
  it "should generate a UUID before validation" do
    @connection.uuid.should be_nil
    @connection.valid?
    @connection.uuid.should_not be_nil
  end
end