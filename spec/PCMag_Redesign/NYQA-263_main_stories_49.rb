require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify all main stories have images and titles" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify all main stories have images and titles" do
    for i in 1..@Nokogiri.getSize("xpath","//div[(contains(@class,'story'))]") 
      #To check that all stories have image
      @selenium.find_element(:xpath,"//div[(contains(@class,'story'))][#{i}]//img").displayed?.should be == true   
      #To check that all stories have title
      @selenium.find_element(:xpath,"//div[(contains(@class,'story'))][#{i}]//h1").displayed?.should be == true                                
    end
  end  
  
  it "Verify Header Exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer Exists" do
    @lib_obj.check_page_footer.should == true
  end
end
