require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "ValueChange", "Given UiObject is cool" do
  describe "when validating" do
    before(:each) do
      @ui_object = Factory(:text_field)
    end
    
    it "should be cool from the factory" do
      @ui_object.rules << Rules::ValueChange.new(
        :affecting_ui_object_id  => Factory(:hidden_field).id,
        :change_value => "egg"
      )
      @ui_object.should be_valid
    end
    
    it "should not be cool if the rule does not have an affecting_ui_object_id" do
      @ui_object.rules << Rules::ValueChange.new(
        :change_value => "egg"
      )
      @ui_object.should_not be_valid
    end
    
    it "should not be cool if the rule does not have an change value" do
      @ui_object.rules << Rules::ValueChange.new(
       :affecting_ui_object_id  => Factory(:hidden_field).id
      )
      @ui_object.should_not be_valid
    end
  end
end