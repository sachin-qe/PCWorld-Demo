require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Deals TLD link on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @Template.openHomePage
  end  

  it "Verify it goes to correct URL" do
    @Template.clickandwait(@selenium.find_element(:link_text,"Deals"))
    @selenium.current_url.should be == "#{@Template.get_Base_URL}/deals/"
  end

  it "Verify it opens page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it "Verify LogicBuy deal categories exist" do
    @Template.getSize("css","ul#menu-tabs>li").should >= 1
    @selenium.find_elements(:css,"ul#menu-tabs>li").each do|element| 
      element.find_element(:css,"a").displayed?.should == true
    end
  end

  it "Verify the page is populated with the best deals data" do
    for i in @Template.getSize("css","ul#menu-tabs>li")..1
      @Template.getAttribute("css","a.link.get-deal-button.small","href").should include "logicbuy.com" 
      @Template.clickandwait(@selenium.find_element(:css,"#ui-id-#{i}"))
      @Template.getAttribute("css","#ui-tabs-#{i}","aria-expanded").should == "true"
      @Template.getAttribute("css","#ui-tabs-#{i}","aria-hidden").should == "false"
    end
  end

  it "Verify Sort By functionality exists for displayed deals" do
    @Template.clickandwait(@selenium.find_element(:id,"pricesort"))
    @Template.getAttribute("css","#pricesort","class").should == "sort-active"
    @Template.clickandwait(@selenium.find_element(:id,"datesort"))
    @Template.getAttribute("css","#datesort","class").should == "sort-active"
  end

  it"Verify Page Title is correct" do
    @Template.verifyText("css","title","Geek Deals | Geek Tech Deals") 
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
end