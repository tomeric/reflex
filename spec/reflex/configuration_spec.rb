require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')

describe Reflex::Configuration do
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
      Reflex.configure(:username => "user", :password => "password", :url => "http://social.react.com/XmlRpc/")
    end
    
    it "should have a username" do
      @configuration.username.should == "user"
    end
    
    it "should have a password" do
      @configuration.password.should == "password"
    end
    
    it "should have a URL" do
      @configuration.url.should == "http://social.react.com/XmlRpc/"
    end
    
    it "should have a hostname" do
      @configuration.hostname.should == "social.react.com"
    end
    
    it "should have a path" do
      @configuration.path.should == "/XmlRpc/"
    end
    
    describe "URL changes" do
      before(:each) do
        Reflex.configure(:url => "http://www.example.com/API/")
      end
      
      it "should have a changed URL" do
        @configuration.url.should == "http://www.example.com/API/"
      end
      
      it "should have a changed hostname" do
        @configuration.hostname.should == "www.example.com"
      end
      
      it "should have a changed path" do
        @configuration.path.should == "/API/"
      end
    end
  end
end