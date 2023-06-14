require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Top Left Article from Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @Template.openHomePage
  end  
  
  it "Verify it goes to the article page" do
    $link_title = @selenium.find_element(:css,"article[ctr='Hero 1'] h3>a").text
    $href_val = @Template.getAttribute("css","article[ctr='Hero 1'] h3>a","href")
    @Template.clickandwait(@selenium.find_element(:css, "article[ctr='Hero 1'] h3>a"))
    @selenium.current_url.should include "#{$href_val}" 
  end
   
  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it "Verify Page Title is correct" do
    @Template.verifyText("css","title","#{$link_title}")
  end
  
  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
 
  it "Verify Top Next and Top Previous article links exist" do
    @Template.next_previous_at_top
  end

  it "Verify Next and Previous article links and TOP link on Bottom exist " do
    @Template.next_previous_at_bottom
  end

  it "Verify Article body exists " do
    @selenium.find_element(:css,"div.articleinfo>article").displayed? == true
  end

  it "Verify TOP link and check it actually goes to the top  " do
    @Template.top_link_check
  end

  it "Verify Google_ads, Geek Newsletter block ,More Geek block,geek widget and adunit exists on left nav" do
    @Template.leftpanel_widget_displayed
  end

  it "Verify Disqus module exists" do
    @Template.check_disqus_comment_section
  end
  
  it "Verify Outbrain module exists" do
    @Template.check_outbrain_module
  end
end
