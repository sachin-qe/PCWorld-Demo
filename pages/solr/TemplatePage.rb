require 'rake'
require "selenium-webdriver"
require "spec_helper"
require "open-uri"
require "rspec"
require "Function_Library"
require "Nokogiri_Library"

class TemplatePage 

  def initialize(driver)
    @lib_obj=Function_Library.new
    @driver=driver   
  end 

  def openHomePage
  	  baseurl = @lib_obj.get_Base_URL
     @driver.get(baseurl)
     sleep 3
     print "openpage"
     if($browser == "ipad")
        ipad_overlay_handle
     end
     @lib_obj.waitforpagetoload
    begin
      @wait.until {  @driver.find_element(:id, "cboxClose") }
      if @driver.find_element(:id, "cboxClose")
        @driver.find_element(:id, "cboxClose").click
        @wait.until { @driver.find_element(:id, "cboxClose").displayed? == false }
      end
    rescue Exception => e
   end    
  end
end