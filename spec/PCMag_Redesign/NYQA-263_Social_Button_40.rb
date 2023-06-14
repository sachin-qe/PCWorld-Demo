require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "open-uri"

describe "Verify the Follow Us Module exists on the Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)   
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify there is a button for Google plus" do
    @selenium.find_element(:css,".gplus>img").displayed?.should be == true
  end

  it "Verify there is a button for Facebook" do
    # Check that there is a button for Facebook
    @selenium.find_element(:css,".facebook>img").displayed?.should be == true
  end

  it "Verify there is a button for Twitter" do
    # Check that there is a button for Twitter
    @selenium.find_element(:css,".twitter>img").displayed?.should be == true
  end

  it "Verify there is a button for StumbleUpon" do
    # Check that there is a button for StumbleUpon
    @selenium.find_element(:xpath,"//div[@class='social-bar']/ul/li[4]//img").displayed?.should be == true
  end

  it "Verify there is a button for Linked in" do
    # Check that there is a button for Linked in
    @selenium.find_element(:css,".linkedin>img").displayed?.should be == true
  end

  it "Verify there is a button for Pinterest" do
    # Check that there is a button for Pinterest
    @selenium.find_element(:css,".pinit>img").displayed?.should be == true
  end
end # Describe Ends
