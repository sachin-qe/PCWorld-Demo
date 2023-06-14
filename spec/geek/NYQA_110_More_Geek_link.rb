require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify More Geek link on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end  

  it "Verify it Goes to correct URL" do
    @selenium.execute_script("document.getElementById('menu-footer-links').scrollIntoView()")
    @Template.clickandwait(@selenium.find_element(:css,"span.next"))
    @selenium.current_url.should == "#{@Template.get_Base_URL}/page/2/" 	
  end

  it "Verify Open Link page with response code 200" do
    @Template.verify_response_code(200).should == true
  end

  it "Verify that infinite scrolling exists" do
    @Template.infinite_scroll
  end

  it "Verify The page is populated with articles" do
    @Template.getSize("css","div.section2").should >= 1
    @selenium.find_elements(:css,"div.section2").each do|element|
      element.displayed?.should == true
    end
  end

  it "Verify Page Title is correct " do
    @Template.verifyText("css","title","Page 2: Tech News, Reviews & Tips | Geek.com")
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
end # Describe end
