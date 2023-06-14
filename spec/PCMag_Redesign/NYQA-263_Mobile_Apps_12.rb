require 'rake'
require 'selenium-webdriver'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Mobile Apps Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on APPS" do
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Apps']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end

  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Mobile Apps")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/mobile-apps"
  end 
  
  it "Verify it opens Mobile Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correc" do
    @Nokogiri.verifyText("css","title","Mobile App Reviews | Mobile Apps Review | PCMag.com")
  end
  
  it "Verify Find a Mobile App by Price exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
  end
  
  it "Verify Find a Mobile App by Company exists" do 
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
  end
  
  it "Verify Find a Mobile App by Type exists" do
    @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
    @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Type")
  end 
  
  it "Verify 10 Must-Have Windows Phone Apps" do
    @selenium.find_element(:link,"10 Must-Have Windows Phone Apps" ).displayed?.should == true
  end
  
  it "Verify The 75 Best Android Apps exists" do
    @selenium.find_element(:link, "The 75 Best Android Apps").displayed?.should == true
  end 
  
  it "Verify The 100 Best iPhone Apps exists" do 
    @selenium.find_element(:link, "The 100 Best iPhone Apps").displayed?.should == true 
  end 
  
  it "Verify The 100 Best iPad Apps exists" do
    @selenium.find_element(:link, "The 100 Best iPad Apps").displayed?.should == true 
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
