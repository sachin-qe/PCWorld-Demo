require 'rake'
require "selenium-webdriver"
require "Nokogiri_Library"
require "spec_helper"
require "open-uri"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

class Stories < TemplatePage
	  
  def initialize(driver)
  	super(driver)  	
  	@driver=driver
    @Pagination = Pagination.new(:css,'.pagerclass')
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30) 
  end

  def openPage
	 @driver.find_element(:css,"#main_nav").find_element(:xpath,".//a[contains(@href,'/features')]").click   
  end

  def verifyPagination

  	 @size= @Pagination.getSize

     for i in 1..@size -1

        # wait for Features story to be displayed

        @wait.until { @driver.find_element(:css,'#features')}      
        @wait.until { @driver.find_element(:css,'#features').displayed? == true }
        previousText = @driver.find_element(:css,'#features').text

        # click on Move Next in Pagination

        @Pagination.moveNext

        # wait for Features story to be displayed

        @wait.until { @driver.find_element(:css,'#features')}      
        @wait.until { @driver.find_element(:css,'#features').displayed? == true }
        currentText = @driver.find_element(:css,'#features').text

        previousText.should_not == currentText
    end

    for i in 1..@size -1

        # wait for Features story to be displayed

        @wait.until { @driver.find_element(:css,'#features')}      
        @wait.until { @driver.find_element(:css,'#features').displayed? == true }
        previousText = @driver.find_element(:css,'#features').getText

        # click on Move Previous in Pagination

        @Pagination.movePrevious

        # wait for Features story to be displayed

        @wait.until { @driver.find_element(:css,'#features')}      
        @wait.until { @driver.find_element(:css,'#features').displayed? == true }
        currentText = @driver.find_element(:css,'#features').getText

        previousText.should_not == currentText
    end
  end
end