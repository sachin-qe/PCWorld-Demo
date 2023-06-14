require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify the Forums Archive Link can be navigated to from the Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end

  it "Verify Goes to the Forums Archive page" do
    @Template.clickandwait(@selenium.find_element(:css,"li#menu-item-1550234>a"))
    @selenium.current_url.should == "#{@Template.get_Base_URL}/forums/"
  end

  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","The Geek.com forum, message board & community discussion - Geek.com")  
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
  
  it "Verify Page is populated with Glossary content  " do
    @selenium.find_element(:css,"table.content").displayed? == true
    @selenium.find_elements(:css,"table.content td").size.should >= 1
  end
end
