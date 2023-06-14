require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Security Link on Homepage" , :selenium => true,:retry => 3 do
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
      it "Verify it should be able to click on SECURITIES" do
        # Click on 'SECURITIES' Link
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Security']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    else
      it "Verify it should be able to click on All Reviews-SECURITIES link" do
        @lib_obj.open_homepage
        # Mouse hover over All Reviews link
        @lib_obj.mousehover("link","ALL REVIEWS")
        @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='security']"))
        @wait.until{ @selenium.find_element(:css, "h1").displayed?.should ==true}
      end
    end

    it "Verify it should have the correct header" do
      @Nokogiri.verifyText("css","h1","Security")
    end

    it "Verify it opens Security page with response code 200" do
      @lib_obj.verify_response_code(200).should == true
    end

    it "Verify it goes to correct URL" do
      @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/reviews/security-software"
    end

    it "Verify Page Title is correct" do
      @Nokogiri.verifyText("css","title","Security - Reviews and Price Comparisons from PC Magazine")
    end

    it "Verify Find a Security Product by Price exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[1]").displayed?.should == true
        @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[1]/h4","Price")
    end

    it "Verify Find a Security Product by Company exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[2]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[2]/h4","Company")
    end

    it "Verify Find a Security Product by Categories exists" do
      @selenium.find_element(:xpath, "//div[@class='prod-criteria']/div[3]").displayed?.should == true
      @Nokogiri.verifyText("xpath","//div[@class='prod-criteria']/div[3]/h4","Categories")
    end

    it "Verify Best Antivirus Software exists" do
      @selenium.find_element(:link, "Best Antivirus Software").displayed?.should == true
    end

    it "Verify The Best Security Suites exists" do
      @selenium.find_element(:link, "The Best Security Suites").displayed?.should == true
    end

    it "Verify Security Watch Blog exists" do
      @selenium.find_element(:link, "Security Watch Blog").displayed?.should == true
    end

    it "Verify How to Create Strong Passwords exists" do
      @selenium.find_element(:link, "How to Create Strong Passwords").displayed?.should == true
    end

    it "Verify Search Results is populated with products" do
      @Nokogiri.getSize("css",".product-item").should >= 1
    end

    it "Verify Header exists" do
      @lib_obj.check_page_header.should == true
    end

    it "Verify Footer exists" do
      @lib_obj.check_page_footer.should == true
    end
  end#for loop end
end # Describe ends

