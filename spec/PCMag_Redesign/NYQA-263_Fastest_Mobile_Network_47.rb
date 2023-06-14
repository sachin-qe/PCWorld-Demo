require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Award Winners-Fastest Mobile Network" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it should be able to click on Fastest Mobile Network link" do
    # @selenium.execute_script("document.getElementById('award-winners').scrollIntoView()")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//div[@id='award-winners']/ul/li[3]//img"))
  end
  
  it "Verify the page response code" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify that the page contents gets loaded " do
    @selenium.find_element(:css, "#content").displayed?.should be_true
  end

  it "Verify page header exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify page footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end # Describe end