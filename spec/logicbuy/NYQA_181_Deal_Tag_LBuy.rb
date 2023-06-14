require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Deal Tag Pages", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @selenium.get "#{@base_url}/tagdeals/free-credit"
  end
 
  it "Verify page response code is 200" do
    @lib_obj.waitforpagetoload
    @lib_obj.page_response_code.should == true
  end

  it "Verify the page is populated with search results" do
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    @doc.xpath(".//*[@class='newest-deals']/ul/li").size.should >= 1
    #@selenium.find_elements(:xpath, ".//*[@class='newest-deals']/ul/li").size.should >= 1
  end

  describe "Verify for NEWEST FREE CREDIT DEALS" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify Deals are listed in NEWEST FREE CREDIT DEALS section below featured deals in List View" do
      #Featured deals section is not present on this page
      @selenium.find_element(:css, ".deal-list.list-view").displayed?.should be == true
      #@selenium.find_element(:xpath, "//div[@class='newest-deals']/ul").displayed?.should be == true
      #To check that Deals are listed in List view format(default) by checking list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
    end

    it "Verify button to change display from List view to Grid view redisplays deals in grid view" do
      @Template.grid_view_click
    end

    it "Verify button to change display back to List View works and redisplays deals in list view" do
      @Template.list_view_click
    end

    it "Verify for first product, when clicked on product name or image it redirects user to Deal Detail page" do
      #To check for product name
      #href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a","href")
      href_val = "#{@base_url}" + @doc.xpath("//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a").attribute("href")
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
    
    it "Verify for first product, when clicked on Get Deal link is redirects user to deals page of the actual deal website" do
      @lib_obj.response_code_is_302("//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[1]")
    end

    it "Verify for the first product, when clicked on the store link it redirects to the clicked stores LogicBuy page" do
      #href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]","href")
      href_val = "#{@base_url}" + @doc.xpath("//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]").attribute("href")
      #href_val=@selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]").attribute("href")
      #To click the store link just below the 'Get Deal' link
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[2]").click
      @lib_obj.waitforpagetoload
      #@wait.until {@selenium.execute_script("return document.readyState;") == "complete"}
      @selenium.current_url.should == "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
      #@wait.until {@selenium.execute_script("return document.readyState;") == "complete"}
    end

    it "Verify Button to Change sort order to Hot changes title to HOTTEST FREE CREDIT DEALS" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[3]/a").click
      sleep 3 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "HOTTEST FREE CREDIT DEALS"
    end

    it "Verify Button to Change sort order to Expiring changes title to EXPIRING FREE CREDIT DEALS" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[4]/a").click
      sleep 2 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "EXPIRING FREE CREDIT DEALS"
    end

    it "Verify Button to Change sort order to Editors Choice changes title to EDITORS CHOICE FREE CREDIT DEALS" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[5]/a").click
      sleep 2 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "EDITORS' CHOICE FREE CREDIT DEALS"
    end

    it "Verify Button to Change sort order to Price changes title to LOWEST PRICED FREE CREDIT DEALS" do
      @selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[6]/a").click
      sleep 2 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:xpath, "//div[@class='newest-deals']/div/h2").text.should be == "LOWEST PRICED FREE CREDIT DEALS"
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
    @selenium.title.should == "Free Credit Deals | LogicBuy"
  end

  it "Verify Header exists" do 
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do 
    @Template.getFooter.displayed?.should == true 
  end 
end