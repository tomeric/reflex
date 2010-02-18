require File.expand_path(File.join(File.dirname(__FILE__), '..') + '/spec_helper')
require 'fakeweb'

describe Reflex::System do
  include ReflexSpecHelper
  
  before(:all) do
    Reflex.configure(:endpoint => "http://social.react.com/XmlRpc_v2/")
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
  end
  
  describe "list_methods" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v2/", :response => fake_response("System.listMethods"))   
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
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v2/", :response => fake_response("System.methodSignature"))   
    end
    
    it "should call System.methodSignature" do
      Reflex::System.expects(:call).with("System.methodSignature", "System.methodSignature")
      Reflex::System.method_signature("System.methodSignature")
    end
    
    it "should return an array of arguments" do
      Reflex::System.method_signature("System.methodSignature").should be_an_instance_of(Array)
    end
    
    it "should return a signature with 1 parameter" do
      Reflex::System.method_signature("System.methodSignature").should == ["string"]
    end
  end

  describe "method_description" do
    before(:each) do
      FakeWeb.register_uri(:post, "http://social.react.com/XmlRpc_v2/", :response => fake_response("System.methodDescription"))   
    end
    
    it "should call System.methodDescription" do
      Reflex::System.expects(:call).with("System.methodDescription", "System.methodDescription")
      Reflex::System.method_description("System.methodDescription")
    end
    
    it "should return return a hash" do
      Reflex::System.method_description("System.methodDescription").should be_an_instance_of(Hash)
    end
    
    it "should return a method description" do
      Reflex::System.method_description("System.methodDescription")['method']['description'].should == "Our extended version of System.methodSignature, with named parameters and descriptions."
    end
    
    it "should return parameter descriptions" do
      Reflex::System.method_description("System.methodDescription")['parameters']['method']['type'].should == "string"
      Reflex::System.method_description("System.methodDescription")['parameters']['method']['description'].should == "Method to get the description for"
    end
  end

  describe "method_help" do
    it "should call System.methodHelp" do
      Reflex::System.expects(:call).with("System.methodHelp", "System.methodHelp")
      Reflex::System.method_help("System.methodHelp")      
    end

    # Rest of method_help seems broken
  end
end