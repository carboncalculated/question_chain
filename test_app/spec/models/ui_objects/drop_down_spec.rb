require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "UiObjects::DropDown" do
  describe "when validating" do
    before(:each) do
      @ui_object = Factory(:drop_down)
    end
    
    it "should be cool to save" do
      @ui_object.save!
    end
    
    it "should be cool from factory" do
      @ui_object.should be_valid
    end
  end
  
  describe "when saving and setting ui_attributes" do
    before(:each) do
      @ui_object = Factory(:drop_down, :ui_attributes => {:visible => false})
      @ui_object.save!
    end
    
    it "should add the ui_attribute along with the defaults" do
      @ui_object.ui_attributes.should == {:visible => false, :enabled =>true, :value=>""}
    end
  end
end