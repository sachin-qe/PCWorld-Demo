require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "nokogiri"
require "open-uri"

describe "Verify Just Tested right rail widget has stories" , :selenium => true,:retry => 3 do

  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify Just Tested right rail should not be empty" do
    #Check that rail is not empty
    @Nokogiri.getSize("css","div#reviews-stack>ul>li").should >= 1

    #Check that all stories exist
    for i in 1..@Nokogiri.getSize("css","div#reviews-stack>ul>li")
      @selenium.find_element(:xpath, "//div[@id='reviews-stack']/ul/li[#{i}]/a").displayed?.should be == true
    end
  end
end
