require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Advertise page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium) 
    @Template = TemplatePage.new(@selenium)   
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify Should be able to click on Advertise Link" do
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Advertise']")) 
  end

  it "Verify Goes to correct url " do
    @selenium.current_url.should == "#{@lib_obj.get_Base_URL}"+"/advertise.aspx"  
  end

  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify Page title is correct" do
    @Nokogiri.verifyText("css","title","Advertise With Us | LogicBuy")
  end

  it "Verify content exists under the heading ADVERTISE" do
    @selenium.find_element(:xpath,"//div[@class='content_info_about']").displayed?.should == true
  end
  
  it "Verify Links are present in the INFORMATION block on the right rail When clicked on these links it should redirect user to the clicked page" do
    #To check for About Us, Help & FAQ, Join LogicBUY, Newsletter, Press, Contact    
    for i in 1..@Nokogiri.getSize("css","ul.about_links li")
      href = @Nokogiri.getAttribute("xpath","//ul[@class='about_links']/li[#{i}]/a","href")
      @lib_obj.clickandwait(@selenium.find_element(:xpath, "//ul[@class='about_links']/li[#{i}]/a/div[@class='btn']"))
      @selenium.current_url.should include "#{href}"
      if(i != 1)
        @lib_obj.navigateback
      end 
    end
  end 
  
  it "Verify Hottest Daily Deals Widget exists on Right Rail" do
    @Template.getHottestDailyDeals.displayed?.should == true
  end

  it "Verify Latest Stories Widget exists on Right Rail" do
    @Template.getLatestStoriesWidget.displayed?.should == true
  end
  
  it "Verify Find us on Facebook block exists below the Latest Stories widget on the right rail" do
    @selenium.find_element(:css, "iframe[title='fb:fan Facebook Social Plugin']").displayed?.should == true
  end

  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true 
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true
  end
end