require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Search functionality on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify It should be able to click on search icon" do
    @selenium.find_element(:css,".search-input").send_keys("apple")
    @selenium.find_element(:css,".search-icon").enabled?.should be == true
    @selenium.find_element(:css,".search-icon").click
  end

  it "Verify It goes to correct url" do
    @selenium.current_url.should include "apple"  
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","apple")
  end

  it "Verify search results river should not be empty" do
    @Nokogiri.getSize("css","ul.items>li").should >= 1
  end
  
  it "Verify Header Exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer Exists" do
    @lib_obj.check_page_footer.should == true
  end
end
