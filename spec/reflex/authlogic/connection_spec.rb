require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Reflex::Authlogic::Connection do
  before(:each) do
    @connection = Reflex::Authlogic::Connection.new
  end
  
  it "should generate a UUID before validation on create" do
    @connection.uuid.should be_nil
    @connection.valid?
    @connection.uuid.should_not be_nil
  end
  
  it "should not update a UUID on update validations" do
    @connection.valid?
    @connection.save(false)
    
    lambda {
      @connection.valid?
    }.should_not change(@connection, :uuid)
  end
end