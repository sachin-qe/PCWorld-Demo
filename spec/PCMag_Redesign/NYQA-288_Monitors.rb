require 'rake'
require 'selenium-webdriver'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Monitors Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-MONITORS" do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='monitors']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Monitors")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/category2/0,2806,2355089,00.asp"
  end 
  
  it "Verify it opens Monitor Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct " do
    @Nokogiri.verifyText("css","title","Monitor Reviews & Price Comparisons from PCMag.com")
  end
  
  it "Verify Find a Monitor  by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end
  
  it "Verify Find a Monitor by Company exists" do 
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end
  
  it "Verify Find a Monitor by Screen Size exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Screen Size")
  end 
  
  it "Verify How to Buy an LCD Monitor exists" do
    @selenium.find_element(:link, "How to Buy an LCD Monitor").displayed?.should == true 
  end
  
  it "Verify How We Test LCD Monitors exists" do
    @selenium.find_element(:link, "How We Test LCD Monitors").displayed?.should == true
  end 
  
  it "Verify A Portable USB Monitor exists " do 
    @selenium.find_element(:link, "A Portable USB Monitor").displayed?.should == true 
  end 
  
  it "Verify Acer's 3D Monitors exists" do
    @selenium.find_element(:link, "Acer's 3D Monitors").displayed?.should == true 
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
