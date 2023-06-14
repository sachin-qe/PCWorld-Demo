require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"

describe "Verify Features TLD on PCMag Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it should be able to click on Features TLD" do
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Features']"))
  end

  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","h1","Features")
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "features"
  end

  it "Verify it opens News and Opinion page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it displays 4 headline stories" do
    @Nokogiri.getSize("css",".top-image").should == 4
  end

  it "Verify River is populated with stories" do
    @Nokogiri.getSize("css","#archive-river>ul>li").should >= 1
    # @selenium.find_elements(:id, "news-river").size.should >= 1
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Features")
  end

  it "Verify Header Exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer Exists" do
    @lib_obj.check_page_footer.should == true
  end
end
