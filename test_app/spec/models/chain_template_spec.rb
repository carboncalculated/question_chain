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
end