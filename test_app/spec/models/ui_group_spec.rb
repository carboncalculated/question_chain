require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "UiGroup" do
  describe "when validating" do
    before(:each) do
      @ui_group = Factory.build(:ui_group)
    end
    
    it "should be cool from the blueprint" do
      @ui_group.should be_valid
    end
    
    it "should not be cool without a name" do
      @ui_group.name = nil
      @ui_group.should_not be_valid
      
    end
    
    it "should not be cool without a label" do
      @ui_group.label = nil
      @ui_group.should_not be_valid
    end
    
    it "should not be cool if it does not have a question" do
      @ui_group.question = nil
      @ui_group.should_not be_valid
    end
  end
    
  describe "when assign some ui_objects", "1 text field, 1 relatable_category_drop_down, 1 object_reference_drop_down" do
    before(:each) do
      @ui_group = Factory.build(:ui_group)
      @ui_group.save
      @text_field = @ui_group.text_fields.create!(Factory.attributes_for(:text_field))
      @relatable_category_drop_down = @ui_group.relatable_category_drop_downs.create!(Factory.attributes_for(:relatable_category_drop_down))
      @object_referenece_drop_down = @ui_group.create_object_reference_drop_down(Factory.attributes_for(:object_reference_drop_down))
    end
    
    it "should have 3 ui_objects" do
      @ui_group.ui_objects.size.should == 3
    end
    
    it "should have 1 relatable_category drop down" do
      @ui_group.relatable_category_drop_downs.size.should == 1
    end
    
    it "should have 1 object_reference drop down" do
      @ui_group.object_reference_drop_down.should_not be_nil
    end
    
    it "should have 1 text field" do
      @ui_group.text_fields.size.should == 1
    end
    
  end
end