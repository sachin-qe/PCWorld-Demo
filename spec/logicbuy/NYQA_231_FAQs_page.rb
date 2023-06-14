require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify FAQs page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_base_URL(@base_url)
  end

  it "Verify to Click on The FAQs from Footer link" do
    @lib_obj.waitforpagetoload
    @selenium.find_element(:css, ".lb-columns>ul>li>a[href*='help']").click
    @lib_obj.waitforpagetoload
  end

  it "Verify page response code is 200" do
    @lib_obj.page_response_code.should == true
  end

  it "Verify Page title is correct" do
    @selenium.title.should == "Help & FAQs | LogicBuy"
  end

  it "Verify the page heading HELP and FAQ exists" do
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    @doc.css("#about_header").text.should == "HELP & FAQ"  
  end

  it "Verify that the page content exists" do
    @selenium.find_element(:class, "content_info").displayed?.should == true   
  end
  
  it "Verify Information block exists on the Right Rail" do
    @selenium.find_element(:css, ".about_links_body.round").displayed?.should == true   
  end
  
  it "Verify Hottest Daily Deals Widget exists on Right Rail" do
    @Template.top_10_Deals_Widget_RightRail
  end

  it "Verify Latest Stories Widget exists on Right Rail" do
    @Template.latest_Story_Widget_RightRail
  end

  it "Verify Find us on Facebook block exists below the Latest Stories widget on the Right Rail." do
    @selenium.find_element(:css,".fb_iframe_widget").displayed?.should == true
  end
  
  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true 
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
end
