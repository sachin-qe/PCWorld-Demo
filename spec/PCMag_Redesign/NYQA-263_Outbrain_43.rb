require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Outbrain Module exists on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify Head caption is displayed" do
    @selenium.find_element(:css, "span.ob_org_header").displayed?.should be_true
  end  
  
  it "Verify Outbrain widget is displayed" do
    @selenium.find_element(:css, ".ob_container").displayed?.should be_true
  end  

  it "Verify number of stories in Outbrain widget" do 
    @Nokogiri.getSize("css",".ob_container_recs>a").should == 6
  end  

  it "Verify number of images in Outbrain widget" do 
    @Nokogiri.getSize("css",".ob_container_recs img").should == 6
  end  
  
  it "Verify number of Captions in Outbrain widget" do  
    @Nokogiri.getSize("css",".ob_container_recs .strip-rec-link-title.ob-tcolor").should == 6
  end
end # Describe end
