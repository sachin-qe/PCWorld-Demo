require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Page articles archives" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @selenium.get("#{@Template.get_Base_URL}/articles/archives/2006/page/143/")
  end  
  
  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct" do
    @Template.verifyText("css","title","January 2006 | Archives | Geek.com")
  end

  it"Verify Next Page link is present on bottom of the page "do
    @selenium.find_element(:css,"span.next").displayed? == true
  end

  it "Verify articles archive links are present on page" do
    @Template.getSize("css","ul.archive>li").should >= 1
    @selenium.find_elements(:css,"ul.archive>li").each do|element|
      element.displayed?.should == true
    end
  end
  
  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end

  it "Verify Follow on Google plus, Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end
end
