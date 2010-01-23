require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')
require 'fakeweb'

describe Reflex::System do
  before(:all) do
    Reflex.configure(:url => "http://social.react.com/XmlRpc/")
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end
  
  describe "list_methods" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc/", :response => FakeResponse("System.listMethods"))   
    end
    
    it "should call System.listMethods" do
      Reflex::System.expects(:call).with("System.listMethods")      
      Reflex::System.list_methods
    end
    
    it "should return an array of methods" do
      Reflex::System.list_methods.should be_an_instance_of(Array)
    end
    
    it "should include System.listMethods" do
      Reflex::System.list_methods.should include("System.listMethods")
    end
  end
  
  describe "method_signature" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc/", :response => FakeResponse("System.methodSignature"))   
    end
    
    it "should call System.methodSignature" do
      Reflex::System.expects(:call).with("System.methodSignature", "System.methodSignature")
      Reflex::System.method_signature("System.methodSignature")
    end
    
    xit "should return an array of arguments" do
      Reflex::System.method_signature("System.methodSignature").should be_an_instance_of(Array)
    end
    
    xit "should return a signature with 1 parameter" do
      Reflex::System.method_signature("System.methodSignature").should == ["string"]
    end
  end

  describe "method_description" do
  end

  describe "method_help" do
  end
end