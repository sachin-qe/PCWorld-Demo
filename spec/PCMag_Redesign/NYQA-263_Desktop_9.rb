require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "open-uri"
require "Nokogiri_Library"

describe "Verify Product Guide-Finder Page Desktop Link on Homepage" ,:selenium => true,:retry => 3 do
 
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-Desktops " do
    # Mouse hover over All Reviews link
    @lib_obj.mousehover("link","ALL REVIEWS")
    # Click on 'All Reviews > Desktops' Link
    @lib_obj.clickandwait(@selenium.find_element(:xpath, ".//div[@id='review-dropdown']//a[.='desktops']"))
  end

  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Desktops")
  end

  it "Verify it opens Desktop page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/desktop-computers"
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Desktop Reviews | Desktops Review | PCMag.com")
  end

  it "Verify Find a Desktop by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end

  it "Verify Find a Desktop by Company exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end

  it "Verify Find a Desktop by Type exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Type")
  end

  it "Verify How to Buy a Desktop PC exists " do
    @selenium.find_element(:link, "How to Buy a Desktop PC").displayed?.should == true
  end

  it "Verify Desktops for Business exists" do
    @selenium.find_element(:link, "Desktops for Business").displayed?.should == true  
  end

  it "Verify The 10 Best Desktops exists" do
    @selenium.find_element(:link, "The 10 Best Desktops").displayed?.should == true 
  end

  it "Verify How to Buy a Gaming PC exists" do
    @selenium.find_element(:link, "How To Buy A Gaming PC").displayed?.should == true
  end

  it "Verify Search Results is populated with products " do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end

  it "Verify Header exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end

