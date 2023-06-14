require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

describe "Verify Left Rail Deal of the Day" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)   
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "Verify Left Rail Deal of the Day exists and displayed" do
    @selenium.find_element(:css, "aside#logicbuy_first_deal-2").displayed?.should == true
    @selenium.find_elements(:css, "aside#logicbuy_first_deal-2>*").size.should >= 1
  end
end