require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Follow US on Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "Verify Follow Us-Top Nav Expand exists on the Homepage " do
    @selenium.find_element(:css, "a.facebook").displayed?.should == true
    @selenium.find_element(:css, "a.twitter").displayed?.should == true
    @selenium.find_element(:css, "a.googleplus").displayed?.should == true
    @selenium.find_element(:css, "a.rss").displayed?.should == true
    # Mousehover over Follow us
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.facebook1").displayed?.should == true
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.twitter1").displayed?.should == true
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.googleplus1").displayed?.should == true
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.rss1").displayed?.should == true
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.stumbleupon").displayed?.should == true
    @lib_obj.mousehover("css","li.followus")
    @selenium.find_element(:css, "a.linkedin1").displayed?.should == true
  end
end