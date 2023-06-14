require 'rake'
require 'rest_client'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "nokogiri"
require "open-uri"
require "Nokogiri_Library"

describe "Verify HDTVs Link can be navigated to from the Homepage",:selenium => true,:retry => 3 do
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
      it "Verify it should be able to click on HDTVS " do
        # Click on 'HDTVS' Link
        # Click on 'PHONES' Link
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='HDTVs']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    else
      it "Verify it should be able to click on All Reviews-HDTVS" do
        @lib_obj.open_homepage
        # Mouse hover over All Reviews link
        @lib_obj.mousehover("link","ALL REVIEWS")
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='hdtvs']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    end

    it "Verify it should have the correct header" do
      @Nokogiri.verifyText("css","h1","HDTVs")
    end
    
    it "Verify it opens HDTVs page with response code 200" do
      @lib_obj.verify_response_code(200).should == true
    end
    
    it "Verify it goes to correct URL" do
      @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/HDTV"
    end

    it "Verify Page Title is correct" do
      @Nokogiri.verifyText("css","title","HDTV Reviews | HDTVs Review | PCMag.com")
    end
    
    it "Verify Find a HDTV by Price exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
    end
    
    it "Verify Find a HDTV by Company exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")     
    end
    
    it "Verify Find a HDTV by Screen Size exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Screen Size")     
    end
    
    it "Verify HDTV FAQ exist" do
      @selenium.find_element(:link, "HDTV FAQ").displayed?.should == true
    end

    it "Verify Buying Guide to HDTVs exist" do
      @selenium.find_element(:link, "Buying Guide to HDTVs").displayed?.should == true
    end
    
    it "Verify Plasma vs. LCD vs. LED exist" do
      @selenium.find_element(:link, "Plasma vs. LCD vs. LED").displayed?.should == true 
    end

    it "Verify Top 10 HDTVs exist" do
      @selenium.find_element(:link, "Top 10 HDTVs").displayed?.should == true 
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
end # Describe end



