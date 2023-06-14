require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Networking Link on Homepage", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it should be able to click on All Reviews-NETWORKING link" do
    @lib_obj.open_homepage
    # Mouse hover over All Reviews link
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='networking']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Networking")
  end

  it "Verify it opens Networking page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/networking"
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Networking Reviews, Ratings & Comparisons | PCMag.com")
  end

  it "Verify Find a Networking Product by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end

  it "Verify Find a Networking Product by Company exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end

  it "Verify Find a Networking Product by Categories exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Categories")
  end

  it "Verify How to Buy a Wireless Router exists" do
    @selenium.find_element(:link, "How to Buy a Wireless Router").displayed?.should == true
  end

  it "Verify How To Make Ethernet Cables exists" do
    @selenium.find_element(:link, "How To Make Ethernet Cables").displayed?.should == true 
  end

  it "Verify 10 Security Tips for Hotspots exists" do
    @selenium.find_element(:link, "10 Security Tips for Hotspots").displayed?.should == true
  end

  it "Verify Home Network in 5 Steps exists" do
    @selenium.find_element(:link, "Home Network in 5 Steps").displayed?.should == true
  end

  it "Verify Search Results is populated with products" do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end

  it "Verify Header exists" do
    #Checking Header 
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer exists" do
    #Checking Footer 
    @lib_obj.check_page_footer.should == true
  end
end # Describe ends
