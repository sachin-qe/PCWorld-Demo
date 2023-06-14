require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Glossary link on Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end
  
  it "Verify Goes to the Glossary page" do
    @Template.clickandwait(@selenium.find_element(:css,"li#menu-item-1550233>a"))
    @selenium.current_url.should == "#{@Template.get_Base_URL}/glossary/"
  end
   
  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","Dictionary For Tech Terms | Glossary | Geek.com")  
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
  
  it "Verify Page is populated with Glossary content  " do
    @Template.getSize("css","div.section2").should >= 1
    @selenium.find_elements(:css,"div.section2").each do|element|
      element.displayed?.should == true
    end
  end
  
  it "Verify Follow on Google plus, Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end
end
