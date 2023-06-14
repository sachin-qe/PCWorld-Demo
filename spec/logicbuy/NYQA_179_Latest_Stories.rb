require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Latest Stories TLD Link", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_base_URL(@base_url)
  end

  it "Verify it should be able to click on  Latest Stories link" do
    @lib_obj.waitforpagetoload
    #@wait.until { @selenium.find_element(:xpath, ".//*[@id='sublink_nav']/li[8]/a").displayed? == true }
    @selenium.find_element(:xpath, "//ul[@id='sublink_nav']/li[8]/a/span").click
    @lib_obj.waitforpagetoload
  end

  it "Verify that it goes to correct URL" do
    @selenium.current_url.should == "#{@base_url}/features"  
  end

  it "Verify page response code is 200" do
    @lib_obj.page_response_code.should == true
  end

  it "Verify the page is populated with search results under Latest Stories" do
    #To check that all stories are displayed
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    for i in 1..@doc.css(".feature-list li").size
      @selenium.find_element(:xpath, "//div[@id='features']/ul/li[#{i}]/div[2]/div/a").displayed?.should be == true
    end
  end

  it "Verify pagination works correctly" do
    @lib_obj.pagination(".//*[@id='features']/ul/li[1]/div[2]/div[1]/a")
  end

  it "Verify Article title when clicked redirects user to the Features page for the article" do
    #To check on first link
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath", "//div[@id='features']/ul/li/div[2]/div/a", "href")
    @selenium.find_element(:xpath, "//div[@id='features']/ul/li/div[2]/div/a").click
    @selenium.current_url.should include "#{href_val}"
    @selenium.navigate().back()
  end

  it "Verify Read More button when clicked redirects user to the Features page for the article" do
    # To check Read More of first story
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath", "//div[@id='features']/ul/li/div[2]/div/a", "href")
    @selenium.find_element(:xpath, "//div[@id='features']/ul/li/div[2]/div[3]/div/a").click
    @selenium.current_url.should include "#{href_val}"
    @selenium.navigate().back()
  end

  it "Verify Author name when clicked redirects user to the Authors page" do
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath", "//div[@id='features']/ul/li/div[2]/div[@class='author-update']/a", "href")
    @selenium.find_element(:xpath, "//div[@id='features']/ul/li/div[2]/div[@class='author-update']/a").click
    @selenium.current_url.should include "#{href_val}"
    @selenium.navigate().back
  end

  it "Verify when clicked on Email image redirects user to Contact Us forms page with Subject field set to Attn: <author_name>" do
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath", "//div[@id='features']/ul/li/div[2]/div[@class='author-update']/a[2]", "href")
    @selenium.find_element(:xpath, "//div[@id='features']/ul/li/div[2]/div[@class='author-update']/a[2]").click
    @selenium.current_url.should include "#{href_val}"
    @selenium.navigate().back
  end

  it "Verify Hottest Daily Deals Widget exists on Right Rail " do
    @Template.top_10_Deals_Widget_RightRail
  end

  it "Verify Page title is correct" do
    @selenium.title.should == "Online Tech Deals | LogicBuy"
  end

  it "Verify Header exists" do  
    @Template.getHeader.displayed?.should == true 
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
end # Describe end
