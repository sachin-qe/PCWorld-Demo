require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Computers TLD Link can be navigated from the Homepage", :selenium => true,:retry => 3 do
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

  it "Verify that it Should be able to click on Computers TLD Link" do
    @selenium.find_element(:xpath, "//ul[@id='sublink_nav']/li[1]/a").click
  end

  it "Verify that it goes to correct URL" do
    @lib_obj.waitforpagetoload
    @selenium.current_url.should == "#{@base_url}/categorydeals/computers"  
  end
  
  it "Verify page response code is 200" do
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify the subcategory list for computers is displayed below the menu bar" do
    @selenium.find_element(:css, "#sublink_nav li div ul").displayed?.should be == true 
  end
  
  it "Verify Breadcrumbs exists" do
    @selenium.find_element(:css, ".deal_breadcrumbs ul").displayed?.should be == true
  end
  
  describe "Verify for TOP COMPUTER DEALS" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify Featured Deals section is displayed in area labeled TOP COMPUTER DEALS" do
      @selenium.find_element(:css, ".featured-deal").displayed?.should be == true
      @selenium.find_element(:css, "h1").displayed?.should == true
      @doc.at_css("h1").text.should_not == nil
      @selenium.find_element(:xpath, "//div[@class='heading']/table/tbody/tr/td[2]").displayed?.should be == true
      @doc.xpath("//div[@class='heading']/table/tbody/tr/td[2]").text.should_not == nil
    end
    
    it "Verify at least one product exists if Features Deals Section is present" do
      @doc.css(".featured-deal ul li").size.should be >= 1
    end
    
    it "Verify for first product Hotness Meter exists" do
      @selenium.find_element(:xpath, "//div[@class='featured-deal']/ul/li[1]/div/div/div[@id='HotnessMeter']/img").displayed?.should be == true
    end
    
    it "Verify for first product when clicked on product name and image it should redirect to clicked products deal page" do
      #To check for product name
      href_val = @Nokogiri.getAttribute("xpath", "//div[@class='featured-deal']/ul/li[1]/div/div/h2/a", "href")
      @selenium.find_element(:xpath, "//div[@class='featured-deal']/ul/li[1]/div/div/h2/a").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back 
      @lib_obj.waitforpagetoload
    
      #To check for image           
      @selenium.find_element(:xpath, "//div[@class='featured-deal']/ul/li[1]/div/div/a/img").click
      @selenium.current_url.should include "#{href_val}"  
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
    
    it "Verify for first product when clicked on Get Deal link it redirects user to deal page of the clicked products website" do
      @lib_obj.response_code_is_302("//div[@class='featured-deal']/ul/li[1]/div/div/div[@class='fb-like']/a[1]")
    end
    
    it "Verify for the first product when clicked on the store link it redirects to the clicked stores LogicBuy page" do
      href_val = @Nokogiri.getAttribute("xpath", "//div[@class='featured-deal']/ul/li[1]/div/div/div[@class='fb-like']/a[2]", "href")
      #To click the store link just below the 'Get Deal' link
      @selenium.find_element(:xpath, "//div[@class='featured-deal']/ul/li[1]/div/div/div[@class='fb-like']/a[2]").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
  end # Descibe ends for TOP COMPUTER DEALS
  
  describe "Verify for NEWEST COMPUTER DEALS" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify Deals are listed in NEWEST COMPUTER DEALS section below featured deals in List View format" do
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul").displayed?.should be == true
      #To check that Deals are listed in List view format(default) by checking list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
    end
    
    it "Verify Button to change display from List view to Grid view redisplays deals in grid view" do
      @selenium.find_element(:css,".grid-btn a").click
      #To check grid view button is active
      @selenium.find_element(:css, ".grid-btn a").attribute("class").should be == "active"
    end
    
    it "Verify Button to change display back to List View works and redisplays deals in list view" do
      @selenium.find_element(:css, ".list-btn a").click
      #To check list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
    end
    
    it "Verify for first product Hotness Meter exists" do
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@id='HotnessMeter']/img").displayed?.should be == true
    end
    
    it "Verify for first product when clicked on product name and image it should redirect to clicked products deal page" do
      #To check for product name
      href_val = @Nokogiri.getAttribute("xpath", "//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a", "href")
      #href_val = @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a").attribute("href")
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    
      #To check for image          
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div/a/img").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
    
    it "Verify for first product when clicked on Get Deal link it redirects user to deal page of the clicked products website" do
      @lib_obj.response_code_is_302("//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[1]")
    end
    
    it "Verify for the first product when clicked on the store link it redirects to the clicked stores LogicBuy page" do
      href_val = @Nokogiri.getAttribute("xpath", "//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]", "href")
      #To click the store link just below the 'Get Deal' link
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should == "#{@base_url}#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
    
    it "Verify pagination is working" do
      @lib_obj.pagination("//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a")
    end
    
    it "Verify Button to Change sort order to Hot changes title to HOTTEST COMPUTER DEALS and displays products accordingly" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[3]/a").click
      sleep 4 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "HOTTEST COMPUTER DEALS"
    end
    
    it "Verify Button to Change sort order to Expiring changes title to EXPIRING COMPUTER DEALS and displays products accordingly" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[4]/a").click
      sleep 4 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "EXPIRING COMPUTER DEALS"
    end
    
    it "Verify Button to Change sort order to Editors Choice changes title to EDITORS CHOICE COMPUTER DEALS and displays products accordingly" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[5]/a").click
      sleep 4 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "EDITORS' CHOICE COMPUTER DEALS"
    end
    
    it "Verify Button to Change sort order to Price changes title to LOWEST PRICED COMPUTER DEALS and displays products accordingly" do
      @wait.until{ @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[6]/a").displayed? == true }
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[6]/a").click
      sleep 4 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "LOWEST PRICED COMPUTER DEALS"
    end
  end # Describe ends for NEWEST COMPUTER DEALS

  it "Verify Hottest Daily Deals Widget exists on Right Rail" do
    @Template.top_10_Deals_Widget_RightRail
  end
  
  it "Verify Latest Coupons Widget exists on Right Rail" do
    @Template.latest_Coupon_Widget_RightRail
  end
  
  it "Verify Latest Stories Widget exists on Right Rail" do
    @Template.latest_Story_Widget_RightRail
  end
  
  it "Verify Page title is correct" do
    @selenium.title.should == "Computer Deals | LogicBuy"
  end
  
  it "Verify Header exists" do 
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do 
    @Template.getFooter.displayed?.should == true 
  end 
end # Describe end
