require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"

describe "Verify Bottom Ad on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  

  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify Bottom banner ad exists" do
    @selenium.find_element(:css,"div#lb-content>div.dartAd iframe").displayed?.should == true
  end

  it "Verify banner ad size" do
    @Nokogiri.getAttribute("css","div#lb-content>div.dartAd iframe","width").should == "728"
    @Nokogiri.getAttribute("css","div#lb-content>div.dartAd iframe","height").should == "90"
  end
end