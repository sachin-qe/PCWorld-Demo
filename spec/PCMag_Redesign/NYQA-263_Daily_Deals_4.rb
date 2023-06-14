require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "open-uri"
require "Nokogiri_Library"

describe "Verify Daily Deals TLD Link on Homepage" ,:selenium => true,:retry => 3 do
  environment = ENV['env']
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    #Production Base_URL
    if environment == "production"
      @lib_obj.open_homepage
    else
      @lib_obj.ad_handle
    end
  end

  it "Verify it should be able to click on Daily Deals TLD " do
    # Click on Link Daily Deals
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Deals']"))
  end

  it "Verify it goes to correct url" do
    if environment == "production"
      @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/best-deals-today"
    else
      @selenium.current_url.should include "http://dev.bdt.pcmag.com"
    end    
  end

  it "Verify it opens Daily Deals page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it displays 1 Featured Deal" do
    @Nokogiri.getSize("css",".featured").should == 1
  end

  it "Verify river is populated with deals" do
    if environment == "production"
      @Nokogiri.getSize("css",".deal").should >= 1
    else
      @Nokogiri.getSize("css","#sort-all-deals").should >= 1
    end
  end

  it "Verify Page Title is correct" do
    if environment == "production"
      @Nokogiri.verifyText("css","title","Best Deals Today | The best deals refreshed daily")
    else
      @Nokogiri.verifyText("css","title","Best Deals Today | PCMag | The best deals refreshed daily")
    end
  end

  it "Verify Header Exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer Exists" do
    @lib_obj.check_page_footer.should == true
  end
end

