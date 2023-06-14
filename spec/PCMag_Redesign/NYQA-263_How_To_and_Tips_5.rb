require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify How To & Tips Link can be navigated to from the Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
   
  it "Verify it should be able to click on How To & Tips Link" do
    # Click on Link How To & Tips Link
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='How-To']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end

  it "Verify it goes to correct URL" do
    # Check the current url
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/tips"      
  end 
  
  it "Verify it opens How To & Tips Link page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page has correct Header: Tips & How Tos" do
    @Nokogiri.verifyText("css","h1 > span","Tips & How Tos")
  end
  
  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Tips, Solutions & How Tos from PCMag.com")
  end

  it "Verify  One headline article" do
    @Nokogiri.getSize("css",".top-rcimage").should == 1
  end
  
  it "Verify 4 Subfeature articles" do
    @Nokogiri.getSize("css",".top-rc-products").should == 4
  end
  
  it "Verify More Tips river populated with articles" do
    @Nokogiri.getSize("css","div#more-story>ul>li").should be >= 1
  end
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true    
  end
end
