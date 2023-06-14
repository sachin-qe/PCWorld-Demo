require 'rake'
require 'selenium-webdriver'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify MP3PLAYERS Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-MP3PLAYERS" do
    # Mouse hover over All Reviews link
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='mp3 players']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","MP3 Players")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/mp3-players"
  end 
  
  it "Verify it opens mp3players Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","MP3 Player Reviews | MP3 Players Review | PCMag.com")
  end
  
  it "Verify Find an MP3 Player by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end
  
  it "Verify Find an MP3 Player by Company exists" do 
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end
  
  it "Verify Find an MP3 Player by Player Type exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Player Type")
  end 
  
  it "Verify How to Buy an MP3 Player exists" do
    @selenium.find_element(:link, "How to Buy an MP3 Player").displayed?.should == true 
  end
  
  it "Verify Headphone Buying Guide exists" do
    @selenium.find_element(:link, "Headphone Buying Guide").displayed?.should == true
  end 
  
  it "Verify Best Wireless Headphones exists" do 
    @selenium.find_element(:link, "Best Wireless Headphones").displayed?.should == true 
  end 
  
  it "Verify Top AirPlay Speakers exists" do
    @selenium.find_element(:link, "Top AirPlay Speakers").displayed?.should == true 
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
end # Describe Ends
