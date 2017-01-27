require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"

describe "Verify Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
	# Selenium::WebDriver::Firefox::Binary.path='/opt/firefox45/firefox'
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to load the homepage" do
    # Mouse hover over All Reviews link
	  # browser.goto('www.pcworld.com')    
  end

end