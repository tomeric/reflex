require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')

describe Reflex::Configuration do
  include ReflexSpecHelper
  
  before(:each) do
    @configuration = Reflex::Configuration.instance
  end
  
  describe "Singleton" do
    it "should not allow instantiation" do
      lambda { Reflex::Configuration.new }.should raise_error(NoMethodError)
    end
    
    it "should have 1 global instance" do
      Reflex::Configuration.instance.should == @configuration
    end
  end
  
  describe "Reflex#configure" do
    before(:each) do
      Reflex.configure(:key => "key", :secret => "secret", :endpoint => "http://social.react.com/XmlRpc_v1/")
    end
    
    it "should have a key" do
      @configuration.key.should == "key"
    end
    
    it "should have a secret" do
      @configuration.secret.should == "secret"
    end
    
    it "should have an endpoint" do
      @configuration.endpoint.should == "http://social.react.com/XmlRpc_v1/"
    end
    
    it "should have a hostname" do
      @configuration.hostname.should == "social.react.com"
    end
    
    it "should have a path" do
      @configuration.path.should == "/XmlRpc_v1/"
    end
    
    it "should have a port" do
      @configuration.port.should == 80
    end
    
    describe "endpoint changes" do
      before(:each) do
        Reflex.configure(:endpoint => "http://www.example.com:8080/API/")
      end
      
      it "should have a changed URL" do
        @configuration.endpoint.should == "http://www.example.com:8080/API/"
      end
      
      it "should have a changed hostname" do
        @configuration.hostname.should == "www.example.com"
      end
      
      it "should have a changed path" do
        @configuration.path.should == "/API/"
      end
      
      it "should have a changed port" do
        @configuration.port.should == 8080
      end
    end
  end
end