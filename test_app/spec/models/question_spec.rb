require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Question" do
  describe "when validating" do
    before(:each) do
      @question = Factory.build(:flight)
    end
    
    it "should be cool straight from the factory" do
      @question.should be_valid
    end 
  end
end