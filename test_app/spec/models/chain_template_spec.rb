require File.dirname(__FILE__) + '/../spec_helper'

describe "ChainTemplate" do
  describe "when validating" do
    before(:each) do
      @chain_template = Factory.build(:chain_template, :context => {"egg" => "123"})
    end
    
    it "should be cool from the factory" do
      @chain_template.should be_valid
    end
        
    it "should not be cool without a for_resource" do
      @chain_template.for_resource = nil
      @chain_template.should_not be_valid
    end
    it "should not be cool if the context is empty" do
      @chain_template.context = {}
      @chain_template.should_not be_valid
    end
  end
  
  describe "when activating" do
    before(:each) do
      @chain_template = Factory.build(:chain_template, :context => {"egg" => "123"})
    end
    
    it "should be in a pending state to start off with" do
      @chain_template.should be_pending
    end
    
    it "should be in an active state one we have activated it" do
      @chain_template.activate!
      @chain_template.should be_active
    end
  end
  
  describe "when there is an account_id" do
    before(:each) do
      @account_id  = BSON::ObjectId.new.to_s
      @chain_template = Factory(:chain_template, :account_id => @account_id, :context => {"egg" => "123"})
      @chain_template2 = Factory(:chain_template, :context => {"egg" => "123"})
    end
    
    it "should find the account when specifying an account" do
      ChainTemplate.first(:for_resource => "container", :account_id => @account_id).should_not be_nil
    end
    
    it "should find the default if the account_id nil" do
      ChainTemplate.first(:for_resource => "container", :account_id => nil).should_not be_nil
    end
  end
end