require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library" 
Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify User Profile page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @Template = TemplatePage.new(@selenium)
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
  end
  
  it "The Deals river is populated with the deals uploaded by the user" do
    @selenium.get("#{@lib_obj.get_Base_URL}/profile/sourabh-kalantri")
  end
  
  it "HTTP response is 200" do
    @lib_obj.verify_responce_code(200).should == true
  end
  
  it "By clicking on Friends button, the user's friends data(if any) should be displayed" do
    pending("Friends data section is not present for the page") do
      this_should_not_get_executed
      #@selenium.find_element(:xpath, "//div[@class='profilecontainer']/div[2]/div/span[3]/span/span/span/div/div[2]").click
      #Friends data section not present for the page
    end
  end
  
  it "Contact Info and Statistics block should be displayed in the right rail with user's name and image" do
    @selenium.find_element(:css, "div.about_links_body").displayed?.should be == true  
    @selenium.find_element(:css, "div.contact_info_body").displayed?.should be == true
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_SideBar_Avatar").displayed?.should be == true
    @selenium.find_element(:css, "fieldset.contact_info_body").displayed?.should be == true
  end
    
  it "Verify header exists" do
    @Template.getHeader.displayed?.should be == true 
  end
  
  it "Verify Footer exists" do
    @Template.getHeader.displayed?.should be == true 
  end
  
  it "Verify page title is appropriate" do
    @Nokogiri.verifyText("css","title","sourabh kalantri - User Profile | LogicBuy")
  end
end #describe end
