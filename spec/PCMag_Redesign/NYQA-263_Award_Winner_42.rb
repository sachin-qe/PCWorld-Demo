require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"

describe "Very Award Winners module after newsletter signup" , :selenium => true,:retry => 3 do
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
  
  it "Verify Award Winners module after newsletter signup exists" do
    # Check that 'PCMag Award Winners' module exists
    @selenium.find_element(:css, ".adheader416").displayed?.should be == true
    # Check that  Award Winners admodule exists
    # switch to ad frame
    @selenium.switch_to.frame(@selenium.find_element(:css,".ad416 iframe"))
    # Award winner section may not get displayed all the time
    begin
        @selenium.find_element(:css, "#ad-container>div").displayed?.should be == true  
    rescue Exception => e
        @selenium.switch_to.default_content      
        fail(e.message)
    end    
  end

  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true   
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true
  end
end 
