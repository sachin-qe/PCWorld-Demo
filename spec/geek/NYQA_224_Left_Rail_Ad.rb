require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Left Rail Ad for home page" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "Verify Left Rail Ad exists and displayed" do
    @selenium.find_element(:css,"aside#dartwidget-14 iframe").displayed?.should == true
    @selenium.find_elements(:css, "aside#dartwidget-14>*").size.should >= 1
  end
end
