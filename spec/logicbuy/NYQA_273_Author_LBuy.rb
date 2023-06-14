require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Author Detail page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @selenium.get "#{@base_url}/authors/michaelessany"
  end

  it "Verify HTTP response is 200" do
    @lib_obj.page_response_code.should == true
  end

  it "Verify Author image and description is present on the page" do
    #To check for image
    @selenium.find_element(:css, ".user-pic").displayed?.should be == true
    #To check for description
    @selenium.find_element(:css, ".author-bio").displayed?.should be == true
  end

  it "Verify User social links must be displayed under Connect with Michael Essany block" do
    @selenium.find_element(:css, ".author-social").displayed?.should be == true 
  end

  it "Verify Hottest Daily Deal Widget exists" do          
    @Template.top_10_Deals_Widget_RightRail
  end

  it "Verify Header exists" do  
    @Template.getHeader.displayed?.should == true 
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end

  it "Verify page title is appropriate" do
    @selenium.title.should == "Michael Essany Bio | LogicBUY"
  end

  it "Verify Stories uploaded by the author must be listed under the 'Latest Stories by Michael Essany' block" do
    @selenium.find_elements(:css, "#features ul li").size >= 1
  end

  it "Verify for the first story, when clicked, the user must be redirected to the clicked story page" do
    href_val = @selenium.find_element(:xpath, "//ul[@class='feature-list']/li[1]/div[2]/div[1]/a").attribute("href")
    @selenium.find_element(:xpath, "//ul[@class='feature-list']/li[1]/div[2]/div[1]/a").click
    @lib_obj.waitforpagetoload
    @selenium.current_url.should == href_val
  end
end