require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Subscribe page", :selenium => true,:retry => 3 do
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

  it "Verify it should be able to click on Subscribe from Footer link" do
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//a[.='Subscribe']"))
  end

  it"Verify it Goes to correct url" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}/newsletter.aspx"
  end

  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify Page title is correct" do
    @Nokogiri.verifyText("css","title","Email Signup | LogicBuy")
  end

  it "Verify the signup form exists with email address text-box " do
    @selenium.find_element(:css,"div.signup_form").displayed?.should == true  
  end

  it"Verify client-side validations are working (blank field and invalid email id validations)"do
    @lib_obj.clickandwait(@selenium.find_element(:css,"input.signup_button"))
    @Nokogiri.verifyText("css","span#ctl00_ctl00_MainContent_PageContent_validSubscribeEmailRegEx","Please enter a valid Email Address")
  end

  it"Verify Hottest Daily Deals Widget exists on Right Rail"do
    @Template.getHottestDailyDeals
  end

  it"Verify Latest Stories Widget exists on Right Rail"do
    @Template.getLatestStoriesWidget
  end

  it "Verify THE BUZZ block exists"do
    @selenium.find_element(:xpath,"//div[@class='about_links_body'][2]").displayed?.should == true
  end

  it "Verify Header exists" do
    @Template.getHeader  
  end

  it "Verify Footer exists" do
    @Template.getFooter
  end
end


