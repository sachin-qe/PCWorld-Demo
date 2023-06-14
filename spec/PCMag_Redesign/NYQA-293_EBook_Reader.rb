require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify EBOOK READERS Link on Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on All Reviews-EBOOK READERS" do
    # Mouse hover over All Reviews link
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='ebook readers']"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
  end
  
  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Ebook Readers")
  end
  
  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/ebook-readers"
  end 
  
  it "Verify it opens projector Apps page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Ebook Reader Reviews, Ratings & Comparisons | PCMag.com")
  end
  
  it "Verify How to Buy an Ebook Reader exists" do
    @selenium.find_element(:link, "How to Buy an Ebook Reader").displayed?.should == true 
  end
  
  it "Verify Top Ebook Readers exists" do
    @selenium.find_element(:link, "Top Ebook Readers").displayed?.should == true
  end 
  
  it "Verify Amazon Kindle Paperwhite exists" do 
    @selenium.find_element(:link, "Amazon Kindle Paperwhite").displayed?.should == true 
  end 
  
  it "Verify Kobo Aura HD exists" do
    @selenium.find_element(:link, "Kobo Aura HD").displayed?.should == true 
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
