require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "Nokogiri_Library"
require "spec_helper"
require "open-uri"

describe "Verify Each spot for PCMAG Homepage is filled with an element" ,:selenium => true,:retry => 3 do
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

  it "Verify the page response code" do
    @lib_obj.verify_response_code(200).should be == true
  end

  it "Verify that all admodules for the page gets displayed" do
    # Checking for all ad Modules
    @selenium.find_element(:css, ".ad401").displayed?.should be_true
    @selenium.find_element(:css, ".ad403").displayed?.should be_true
    @selenium.find_element(:css, "#ad405-2").displayed?.should be_true
    @selenium.find_element(:css, "#ad405-3").displayed?.should be_true
    @selenium.find_element(:css, "#ad411-2").displayed?.should be_true
    @selenium.find_element(:css, "#ad414-1>iframe").displayed?.should be_true
    @selenium.find_element(:css, "#ad415-1").displayed?.should be_true
    @selenium.find_element(:css ,".adheader416").displayed?.should be_true
  end

  it "Verify that all aritcles for the page gets displayed" do
    # Popular Stack is displayed

    @popularStack = @selenium.find_element(:css, ".popular-stack")
    @popularStack.displayed?.should be_true 

    for i in 1..(@Nokogiri.getSize("css",".popular-stack>div"))
      @popularStack.find_elements(:xpath,"div[#{i}]/*").size.should >= 1        
    end

    @featuredStories = @selenium.find_element(:css, ".featured-stories")
    @featuredStories.displayed?.should be_true 

    for i in 1..(@Nokogiri.getSize("css",".featured-stories>div"))
      @featuredStories.find_elements(:xpath,"div[#{i}]/*").size.should >= 1        
    end

    @reviewsStack = @selenium.find_element(:css, "#reviews-stack")
    @reviewsStack.displayed?.should be_true 

    @outerbrains = @selenium.find_element(:css, ".OUTBRAIN")
    @outerbrains.displayed?.should be_true 

    for i in 1..(@Nokogiri.getSize("css",".OUTBRAIN .ob_container_recs>a"))
      @outerbrains.find_elements(:xpath,"//div[@class='ob_container_recs']/a[#{i}]/div/*").size.should >= 1        
    end
 end
  
  it "Verify page header exists" do
    @lib_obj.check_page_header.should == true
  end
  
  it "Verify page footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end