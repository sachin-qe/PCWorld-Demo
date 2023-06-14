require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"
require "Nokogiri_Library"

describe "Verify Business TLD Link on Homepage" ,:selenium => true,:retry => 3 do
  browser = ENV['browser']
  platform = ENV['platform']

  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
 
  it "Verify it should be able to click on Business TLD " do
    #Click on Link Business TLD   
    @lib_obj.clickandwait(@selenium.find_element(:link, "BUSINESS"))
  end

  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Business")
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/business"
  end

  it "Verify it open Business page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it displays 1 feature story " do
    @Nokogiri.getSize("css",".feature-story").should == 1
  end

  it "Verify it displays 4 popular stories under Feature Story" do
    @Nokogiri.getSize("css",".popular-stories>ul>li").should == 4
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","PC Magazine Small Business (SMB) Center | PCMag.com")
  end

  it "Verify river is populated with stories" do
    @Nokogiri.getSize("css","#more-story").should >= 1
  end

  it "Verify Header Exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer Exists" do
    @lib_obj.check_page_footer.should == true
  end
end
