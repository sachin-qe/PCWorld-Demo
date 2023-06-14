require 'rake'
require "selenium-webdriver"
require "Nokogiri_Library"
require "spec_helper"
require "open-uri"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

class Stores < TemplatePage
	  
  def initialize(driver,pageName)
  	super(driver)
  	@selenium=driver
  	@page=pageName
  	@lib_obj = Function_Library.new
  end
  
  def openPage
  	@selenium.find_element(:xpath,".//a[@href='/stores']/..").find_element(:css,"a").click
  end

  def getMostPopularstores
    return @selenium.find_element(:xpath,".//a[@href='/stores']/..").find_elements(:css, ".dropdown a")
  end

  def getNewestCoupons
    return @selenium.find_elements(:css,"#coupon_body li")
  end

  def getStores
    return @selenium.find_elements(:css,"#store_bg li")
  end

  def getSortOptions
    return @selenium.find_elements(:css,"#pagination_alphabet li") 
  end

end