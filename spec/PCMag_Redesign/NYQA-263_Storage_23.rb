require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Storage Link on Homepage",:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it should be able to click on All Reviews-STORAGE Link" do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='storage']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
 
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Storage Devices")
  end

  it "Verify it opens Storage Device page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/category2/0,2806,2376,00.asp"
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Storage Devices - Reviews and Price Comparisons from PC Magazine")
  end
  
  it "Verify Find a Storage Device by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end

  it "Verify Find a Storage Device by Company exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end

  it "Verify Find a Storage Device by Categories exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Categories")
  end

  it "Verify How to Buy a Hard Drive exists" do
    @selenium.find_element(:link, "How to Buy a Hard Drive").displayed?.should == true
  end

  it "Verify How to Buy a NAS exists" do
    @selenium.find_element(:link, "How to Buy a NAS").displayed?.should == true
  end

  it "Verify Great Tools For Your USB Key exists" do
    @selenium.find_element(:link, "Great Tools For Your USB Key").displayed?.should == true
  end

  it "Verify Weird Storage Formats exists" do
    @selenium.find_element(:link, "Weird Storage Formats").displayed?.should == true
  end
  
  it "Verify Search Results is populated with products" do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should == true
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end # Describe ends
