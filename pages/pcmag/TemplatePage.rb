require 'rake'
require "selenium-webdriver"
require "spec_helper"
require "open-uri"
require "rspec"
require "Function_Library"

class TemplatePage

  def initialize(driver)
    @lib_obj=Function_Library.new
    @driver=driver   
  end 

  def getTopMenu(menuName)
    @driver.find_element(:xpath,".//a[@title='#{pageName}']/..")
  end

  def openTopMenu(menuName)
    getTopMenu(menuName).find_element(:css,"a").click
  end

  def openSubMenu(menuName,subMenuName)
    getTopMenu(menuName).find_element(:css,"a[title='#{subMenuName}']").click   
  end

  def openHomePage
  	 # @driver.find_element(:css,".site-logo>a").click
     baseurl = @lib_obj.get_Base_URL
     @driver.get(baseurl)
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