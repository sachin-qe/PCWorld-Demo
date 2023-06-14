require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

describe "Verify Latest Stories widget on homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  

  it "Verify by default 6 Features (Stories) should be displayed with their image and title" do
    @Nokogiri.getSize("css",".recent_features>ul>li").should == 6
    for i in 1..6
      @selenium.find_element(:xpath, "//div[@class='recent_features']/ul/li[#{i}]").displayed?.should == true
      #To check for title
      @selenium.find_element(:xpath, "//div[@class='recent_features']/ul/li[#{i}]//div").displayed?.should == true
      #To check for image
      @selenium.find_element(:xpath, "//div[@class='recent_features']/ul/li[#{i}]//img").displayed?.should == true
    end
  end

  it "Verify when clicked on See All Stories, it redirects user to the features list page" do
    #To click on 'See All Stories'
    @lib_obj.clickandwait(@selenium.find_element(:css, "div.recent_features>a>img"))
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/features"
    @lib_obj.navigateback
  end

  it "Verify for first story, when clicked, it redirects user to the story page of the story" do
    href_val = @Nokogiri.getAttribute("xpath","//div[@class='recent_features']/ul/li[1]/a","href")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//div[@class='recent_features']/ul/li[1]/a"))
    @selenium.current_url.should include "#{href_val}"
    @lib_obj.navigateback
  end
end #describe end