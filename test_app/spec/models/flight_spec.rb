require File.dirname(__FILE__) + '/../spec_helper'

describe "Flight (Test Model)" do
  describe "when it is CarbonCalculated::Answerable" do
    describe "initializing" do
      before(:each) do
        @flight = Flight.new
      end

      it "should have answerable keys" do
        @flight.keys.should include("question_id")
        @flight.keys.should include("result")
        @flight.keys.should include("answer_params")
        @flight.keys.should include("answer_json")
        @flight.keys.should include("user_id")
        @flight.keys.should include("reference")
        @flight.keys.should include("stored_identifier")
        @flight.keys.should include("_extra_keywords")
      end
      
      it "Should have access to _extra_keyword class method" do
        Flight.should respond_to(:_extra_keyword_methods)
      end
    end
    
    describe "when validating" do
      before(:each) do
        @flight = Factory.build(:flight)
      end
      
      it "should be cool from the factory" do
        @flight.should be_valid
      end
      
      it "should not be cool if there is no question_id" do
        @flight.question_id = nil
        @flight.should_not be_valid
      end
      
      it "should not be cool without a result" do
        @flight.result = nil
        @flight.should_not be_valid
      end
      
      it "should not be cool without a answer_params" do
        @flight.answer_params = nil
        @flight.should_not be_valid
      end
    end
    
    describe "when save", "given that the flight has object with an identifier of beans" do
      before(:each) do
        @flight = Factory.build(:flight)
        @flight.save
      end
      
      it "should have a identifier of 'beans'" do
        @flight.identifier.should == "beans"
      end
      
      it "should be searchable from the saved idenifier" do
        flights = Flight.search "beans"
        flights.first.should == @flight
      end
      
      it "should not be found on a silly search like crumpets" do
        flights = Flight.search "crumpets"
        flights.should be_empty
      end
    end
  
    describe "when save", "given that the flight has more then 1 object reference" do
      before(:each) do
        @flight = Factory.build(:flight)
        @flight.result = {"co2" => 234.234, "object_references" => {"1" => {"identifier" => "what"}, "2" => {"identifier" => "me"}}}
        @flight.save
      end
      
      it "should have a identifier of 'beans'" do
        @flight.identifier.should == "what me"
      end
    end
    
    describe "when save", "with extra keyword methods that result in 'black rebel motocycle' keywords being added" do
      before(:each) do
        @flight = Factory.build(:flight)
        @flight.result = {"co2" => 234.234, "object_references" => {"1" => {"identifier" => "what"}, "2" => {"identifier" => "me"}}}
        @flight.save
      end
      
      it "should find the flight from the search 'black' OR 'motocycle'" do
        flights = Flight.search "black"
        flights.first.should == @flight
        
        flights = Flight.search "motocycle"
        flights.first.should == @flight
      end
    end
  
  end
end
