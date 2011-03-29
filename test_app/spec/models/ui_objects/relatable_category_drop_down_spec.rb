require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "RelatableCategoryDropDown" do
  describe "when validating" do
    before(:each) do
      @rc_drop_down = Factory(:relatable_category_drop_down)
    end
    
    it "should be valid from the factory" do
      @rc_drop_down.should be_valid
    end
  end
end