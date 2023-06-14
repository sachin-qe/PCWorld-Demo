require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Page_Search Result" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end  
  
  it "Verify Page loads with no error" do
    @selenium.find_element(:css,"#s").send_keys("apple")
    @Template.clickandwait(@selenium.find_element(:css,"input.icon"))
  end
   
  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","apple | Search Results  | Geek.com")
  end

  it"Verify text 'Search results for: apple' is present "do
    @Template.verifyText("css","h2.small","Search results for: apple")
  end

  it "Verify page is populated with articles" do
    @Template.getSize("css","div.section2").should >= 1
    @selenium.find_elements(:css,"div.section2").each do|element|
      element.displayed?.should == true
    end
  end
  
  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
end
