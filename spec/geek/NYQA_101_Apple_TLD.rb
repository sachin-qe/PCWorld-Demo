require 'selenium-webdriver'
require 'rspec'
require 'rake'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Apple TLD link on Homepage " ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end  

  it "Verify Goes to correct page" do
    @Template.clickandwait(@selenium.find_element(:xpath,"//a[.='Apple']"))
    @selenium.current_url.should be == "#{@Template.get_Base_URL}/category/apple/"
  end

  it "Verify Open Link page with response code 200" do
    @Template.verify_response_code(200).should == true
  end

  it "Verify that infinite scrolling exists" do
    @Template.infinite_scroll
  end

  it "Verify The page is populated with articles related to Apple category" do
    @Template.getSize("css","div.section2").should >= 1
  end

  it "Verify Page Title is correct " do
    @Template.verifyText("css","title","Apple News & Rumors | Tag Page | Geek.com")
  end

  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true
  end
end # Describe end