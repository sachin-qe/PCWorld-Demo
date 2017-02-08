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
    @driver.find_element(:xpath,"//a[contains(text(), '#{pagename}')]")                      
  end

  def openTopMenu(menuName)
    getTopMenu(menuName).find_element(:css,"a").click
  end

  def openSubMenu(menuName,subMenuName)
    getTopMenu(menuName).find_element(:xpath,"//a[contains(text(), '#{subMenuName}')]").click   
  end

  def openHomePage
    begin
      baseurl = @lib_obj.get_Base_URL
      @driver.get(baseurl)
      @lib_obj.waitforpagetoload  
    rescue Exception => e
      print e
    end   
  end

  def elementisDisplayed(locator, value)
    if (@driver.find_element(locator,value).displayed? == true)
      return true
    else
      return false
    end
  end
end # Class ends 