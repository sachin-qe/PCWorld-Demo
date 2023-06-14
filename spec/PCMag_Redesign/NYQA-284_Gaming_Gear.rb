require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Gaming gear Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-GAMING " do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='gaming']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Gaming")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/category2/0,2806,1638429,00.asp"
  end 
  
  it "Verify it opens Gaming page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct " do
    @Nokogiri.verifyText("css","title","Gaming - Products")
  end
  
  it "Verify Search Results is populated with products " do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end 
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true   
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true
  end
end
