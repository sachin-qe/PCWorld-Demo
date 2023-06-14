require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category_Article_You Might Also Like" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "You Might Also Like widget exists and displayed on article page" do
    # Click on top article
    @lib_obj.clickandwait(@selenium.find_element(:css, ".topcontent h2>a"))
    @selenium.find_element(:css,"span.ob_org_header").displayed?.should == true
    @selenium.find_element(:class, "ob_container").displayed?.should == true
  end
end