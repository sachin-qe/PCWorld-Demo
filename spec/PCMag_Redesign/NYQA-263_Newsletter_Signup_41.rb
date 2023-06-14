require "rake"
require "rspec"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "open-uri"

describe "Verify the Newsletter Signup on Right Rail exists on the Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)  
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify There is a text field" do
    # Check that text field is available 
    @selenium.find_element(:css, "#rruseremail").displayed?.should be == true
  end  
  
  it "Verify There is a button" do
    # Check that the button is available
    @selenium.find_element(:css, "#rr-btn-signup").displayed?.should be == true
  end
end # Describe ends
