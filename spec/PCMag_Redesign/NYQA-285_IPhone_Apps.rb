require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify iPhone Apps Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-IPHONE APPS " do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='iPhone Apps']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","iPhone Apps")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/iphone-apps"
  end 
  
  it "Verify it opens iPhone Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct " do
    pending("Verify title is pending") do
      @Nokogiri.verifyText("css","title","iPhone Apps| PCMag.com").displayed?.should == true
    end 
  end
  
  it "Verify The 100 Best iPhone Apps exists" do
    @selenium.find_element(:link, "The 100 Best iPhone Apps").displayed?.should == true
  end

  it "Verify Review: Snapseed exists" do
    @selenium.find_element(:link, "Review: Snapseed").displayed?.should == true 
  end
  
  it "Verify Review: SugarSync exists" do
    @selenium.find_element(:link, "Review: SugarSync").displayed?.should == true
  end 
  
  it "Verify 10 Must-Have iPhone Apps exists " do 
    @selenium.find_element(:link, "10 Must-Have iPhone Apps").displayed?.should == true 
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
