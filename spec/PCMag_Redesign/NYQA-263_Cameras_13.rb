require 'rake'
require "rspec"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"
require "Nokogiri_Library"

describe "Verify Cameras Link on Homepage" ,:selenium => true,:retry => 3 do
  browser = ENV['browser']
  platform = ENV['platform']

  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end 

  for i in 1..2
    if(i==1)
      it "Verify it should be able to click on CAMERAS " do 
       @lib_obj.clickandwait(@selenium.find_element(:xpath, ".//a[.='Cameras']")) 
       @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    else
      it "Verify it should be able to click on All Reviews-CAMERAS " do
        @lib_obj.open_homepage
        # Mouse hover over All Reviews link
        @lib_obj.mousehover("link","ALL REVIEWS")
        @lib_obj.clickandwait(@selenium.find_element(:xpath, ".//a[.='cameras']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    end

    it "Verify it should have the correct header" do
      @Nokogiri.verifyText("css","h1","Digital Cameras")
    end
      
    it "Verify it opens Cameras TLD with response code 200" do
      @lib_obj.verify_response_code(200).should == true
    end
    
    it "Verify it goes to correct URL" do
      @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/digital-cameras"
    end 
    
    it "Verify Page Title is correct" do
      @Nokogiri.verifyText("css","title","Digital Camera Reviews | Digital Cameras Review | PCMag.com")
    end
    
    it "Verify Find a Camera by Price exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
    end
    
    it "Verify Find a Camera by Company exists" do 
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
    end

    it "Verify Find a Camera by Type exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Type")
    end

    it "Verify The 10 Best Digital Cameras exist" do
      @selenium.find_element(:link, "The 10 Best Digital Cameras").displayed?.should == true
    end

    it "Verify 10 Basic Photo Tips exists" do 
      @selenium.find_element(:link, "10 Basic Photo Tips").displayed?.should == true
    end 
    
    it "Verify Choosing the Right Camera exists" do
      @selenium.find_element(:link, "Choosing the Right Camera").displayed?.should == true
    end 

    it "Verify 5 Advanced Photo Tips exists" do
      @selenium.find_element(:link, "5 Advanced Photo Tips").displayed?.should == true
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
  end # For loop ends
end # Describe ends
