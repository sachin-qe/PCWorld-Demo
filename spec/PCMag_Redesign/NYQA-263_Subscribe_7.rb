require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

describe "Verify the Subscribe Link can be navigated to from the Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify Hover over Subscribe will pop up subscription form" do
    @lib_obj.mousehover("link","SUBSCRIBE")
  end

  it "Verify Subscription form includes" do
    @lib_obj.mousehover("link","SUBSCRIBE")
    # Check first name exist 
    @selenium.find_element(:css,"#firstnamedd").displayed?.should == true
    # Check last name exist
    @selenium.find_element(:css,"#lastnamedd").displayed?.should == true
    # Check address1 exist
    @selenium.find_element(:css,"#addressdd").displayed?.should == true
    # Check address2 exist
    @selenium.find_element(:css,"#address2").displayed?.should == true
    # Check city exist
    @selenium.find_element(:css,"#citydd").displayed?.should == true
    # Check stateselect exist
    @selenium.find_element(:css,"#statedd").displayed?.should == true
    # Check zipcode exist
    @selenium.find_element(:css,"#zipdd").displayed?.should == true
    # Check email exist
    @selenium.find_element(:css,"#emaildd").displayed?.should == true
    # Check cardtype select exist 
    @selenium.find_element(:css,"#cc_type").displayed?.should == true
    # Check credit card number exist
    @selenium.find_element(:css,"#cc_numdd").displayed?.should == true
    # Check placeholder button exist
    @selenium.find_element(:css,"#place_order").displayed?.should == true
    # Check 12 issue radio button exist
    @selenium.find_element(:css,"#radio3").displayed?.should == true
    # Check 24 issue radio button exist
    @selenium.find_element(:css,"#radio4").displayed?.should == true
    element = @selenium.find_element(:css,"#subscribe-covers")
    # Check 3 images of subscribe cover exist
    element.find_elements(:tag_name,"li").size.should == 3
    # Check subscribe issue image exist
    @selenium.find_element(:css,"div.subscibe-issues  a  img").displayed?.should == true
   end
end # Describe ends
