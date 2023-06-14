require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Readers Choice Awards Link on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on Readers Choice Awards Link" do
    @element = @selenium.find_element(:xpath, ".//*[@id='award-winners']/ul/li[2]/a/img")
    @selenium.action.move_to(@element).perform
    @element.click
  end
  
  it "Verify it opens  Readers Choice Awards page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify it goes to Correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/readers-choice"
  end
  
  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","PCMag Readers' Choice Awards")
  end
  
  it "Verify The page is populated with search results" do
    @Nokogiri.getSize("css",".top-rc-categories div").should be >= 1
  end
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should == true
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end # Describe ends
