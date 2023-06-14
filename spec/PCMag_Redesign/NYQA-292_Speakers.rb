require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify SPEAKERS Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-SPEAKERS" do
    # Mouse hover over All Reviews link
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='speakers']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Speakers")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/category2/0,2806,7498,00.asp"
  end 
  
  it "Verify it opens speakers page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Computer Speaker Reviews | Computer Speakers Review | PCMag.com")
  end
  
  it "Verify Find Speakers  by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end
  
  it "Verify Find Speakers  by Company exists" do 
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end
  
  it "Verify Find Speakers by Type exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Type")
  end 
  
  it "Verify Best Wireless Speakers exists" do
    @selenium.find_element(:link, "Best Wireless Speakers").displayed?.should == true 
  end
  
  it "Verify Top-Rated PC Speakers exists" do
    @selenium.find_element(:link, "Top-Rated PC Speakers").displayed?.should == true
  end 
  
  it "Verify How to Buy PC Speakers exists" do 
    @selenium.find_element(:link, "How to Buy PC Speakers").displayed?.should == true 
  end 
  
  it "Verify The AirPlay Elite exists" do
    @selenium.find_element(:link, "The AirPlay Elite").displayed?.should == true 
  end
  
  it "Verify Search Results is populated with products" do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end 
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true   
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true
  end
end # Describe ends
