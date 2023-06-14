require 'rake'
require "selenium-webdriver"
require "Nokogiri_Library"
require "spec_helper"
require "open-uri"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

class Category < TemplatePage
	  
  def initialize(driver,pageName)
  	super(driver)
  	@page=pageName
  	@selenium=driver
  end

  def openPage
	 openTopMenu(@page)
  end

  def verifyFeatureDealsize
  	getFeartureDeals.size.should >= 1   
  end
end