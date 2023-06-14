require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Android Apps Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-ANDROID APPS" do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='android apps']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end

  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Android Apps")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/android-apps"
  end 
  
  it "Verify it opens Android Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct " do
    @Nokogiri.verifyText("css","title","Android Apps")
  end
  
  it "Verify The 100 Best Android Apps exists" do
    @selenium.find_element(:link, "The 100 Best Android Apps").displayed?.should == true
  end
  
  it "Verify The Best Android Games exists" do
    @selenium.find_element(:link, "The Best Android Games").displayed?.should == true
  end 
  
  it "Verify 10 Must-Have Android Apps exists" do 
    @selenium.find_element(:link, "10 Must-Have Android Apps").displayed?.should == true 
  end 
  
  it "Verify The Best Free Android Apps exists" do
    @selenium.find_element(:link, "The Best Free Android Apps").displayed?.should == true 
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
end
