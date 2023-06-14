require 'rake'
require 'rspec'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "open-uri"
require "Nokogiri_Library"

describe "Verify Cell Phones Link on Homepage" ,:selenium => true,:retry => 3 do
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
      it "Verify it should be able to click on PHONES " do
        # Click on 'PHONES' Link
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//ul[@class='subnav-bar']/li[not(contains(@class,'first'))]//a[.='Phones']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    else
      it "Verify it should be able to click on All Reviews-PHONES " do
        @lib_obj.open_homepage
        # Mouse hover over All Reviews link
        @lib_obj.mousehover("link","ALL REVIEWS")
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//div[@id='review-dropdown']//a[.='Phones']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    end
    
    it "Verify it should have the correct header" do
      @Nokogiri.verifyText("css","h1","Cell Phones")
    end

    it "Verify it opens Cell-Phone page with response code 200" do
      @lib_obj.verify_response_code(200).should == true
    end

    it "Verify it goes to correct URL" do
      @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/cell-phones"
    end

    it "Verify Page Title is correct" do 
      @Nokogiri.verifyText("css","title","Cell Phone Reviews | Cell Phones Review | PCMag.com")
    end

    it "Verify Find a Cell Phone by Price exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
    end

    it "Verify Find a Cell Phone by Company exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
    end

    it "Verify Find a Cell Phone by Carrier exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Carrier")
    end

    it "Verify How to Buy a Cell Phone exists" do
      @selenium.find_element(:link, "How to Buy a Cell Phone").displayed?.should == true
    end

    it "Verify Fastest Mobile Networks 2013 exists" do
      @selenium.find_element(:link, "Fastest Mobile Networks 2013").displayed?.should == true
    end

    it "Verify Phones Worth Waiting For exists" do
      @selenium.find_element(:link, "Phones Worth Waiting For").displayed?.should == true
    end

    it "Verify Best Android Phones exists" do
      @selenium.find_element(:link, "Best Android Phones").displayed?.should == true
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
  end# For loop ends
end # Describe ends
