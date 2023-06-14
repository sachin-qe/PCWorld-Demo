require 'selenium-webdriver'
require 'rspec'
require 'rake'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Bottom Next Article on Article Page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @Template.openHomePage
  end  

  it "Verify the Bottom Next Article Link can be navigated to from the Article page." do
    @Template.clickandwait(@selenium.find_element(:css,"article.right h3>a"))
    $link_text = @selenium.find_element(:css,"div.paginationbottom>div.next>a").text
    $href_val = @Template.getAttribute("css","div.paginationbottom>div.next>a","href")
    @selenium.execute_script("document.getElementById('outbrain_widget_1').scrollIntoView()")
    @Template.clickandwait(@selenium.find_element(:css,"div.paginationbottom>div.next>a"))
  end

  it "Verify Open Link page with response code 200" do
    @Template.verify_response_code(200).should == true
  end

  it "Verify Page Title is correct " do
    @Template.verifyText("css","title","#{$link_text}") 
  end

  it "Verify it goes to the article page" do
    @selenium.current_url.should include "#{$href_val}"
  end

  it "Verify article body exists" do
    @selenium.find_element(:css,"div.articleinfo article").displayed? == true
  end

  it "Verify Top Next and Top Previous article links exists" do
    @Template.next_previous_at_top
  end

  it "Verify Bottom Next and Bottom Previous article links exists" do
    @Template.next_previous_at_bottom
  end

  it "Verify Click on TOP link and check it actually goes to the top" do
    @Template.top_link_check
  end

  it "Verify Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end

  it "Verify Outbrain module exists" do
    @Template.check_outbrain_module
  end

  it "Verify Disqus Comment section exists" do
    @Template.check_disqus_comment_section
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
end # Describe end