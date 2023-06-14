require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify User Profile page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @selenium.get "#{@base_url}/profile/sourabh-kalantri"
  end
  
  it "Verify page response code is 200" do
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify by clicking on Friends button that, the users friends data(if any) should be displayed" do
    pending("Friends data section is not present for the page") do
      this_should_not_get_executed
      #@selenium.find_element(:xpath, "//div[@class='profilecontainer']/div[2]/div/span[3]/span/span/span/div/div[2]").click
      #Friends data section not present for the page
    end
  end
  
  it "Verify contact Info and Statistics block should be displayed in the right rail with users name and image" do
    @selenium.find_element(:xpath, "//div[@class='about_links_body']").displayed?.should be == true  
    @selenium.find_element(:xpath, "//div[@class='contact_info_body']").displayed?.should be == true
    @selenium.find_element(:xpath, "//div[@class='about_links_body']/div/div/img").displayed?.should be == true
    @selenium.find_element(:xpath, "//div[@class='about_links_body']/div[4]/fieldset").displayed?.should be == true
  end
    
  it "Verify header exists" do
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
  
  it "Verify page title is appropriate" do
    doc = Nokogiri::HTML(open(@selenium.current_url))
    doc.at_css("title").text.should include "sourabh kalantri - User Profile | LogicBuy"
    # @selenium.title.should be == "sourabh kalantri - User Profile | LogicBuy"
  end
end #describe end
