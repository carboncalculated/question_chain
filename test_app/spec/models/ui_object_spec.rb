require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# @todo should be shared spec
describe "UiObject" do
  describe "when valiating" do
    before(:each) do
      @ui_object = Factory.build(:ui_object)
    end
    
    it "should be cool from the factory" do
      @ui_object.should be_valid
    end
    
    it "should be cool to save" do
      @ui_object.save!
    end
    
    it "should not be cool without a label" do
      @ui_object.label = nil
      @ui_object.should_not be_valid
    end
    
    it "should not be cool if it is not attached group" do
      @ui_object.ui_group_id = nil
      @ui_object.should_not be_valid
    end
    
    it "should set default attributes" do
      @ui_object.valid?
      @ui_object.ui_attributes.should == {:visible => true, :enabled => true, :value => ""}
    end
  end  
end