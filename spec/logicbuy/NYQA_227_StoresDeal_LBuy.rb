require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Stores Deal Page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_base_URL("#{@base_url}/deals/dell-home")
  end

  it "Verify page response code is 200" do
    @lib_obj.waitforpagetoload
    @lib_obj.page_response_code.should == true
  end
  
  describe "Verify Subcategory Page footer dell home" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify the other deals links are displayed in Most Popular panel below the header and category menu" do
      #To check that all deals links are displayed
      for i in 1..@doc.css(".dropdown.popularstores ul li").size      
        @selenium.find_element(:xpath, "//div[@class='dropdown popularstores']/ul/li[#{i}]/a").displayed?.should be == true
      end
    end
  
    it "Verify that Breadcrumbs with clickable links are present that redirect to the clicked page." do
      #To check that links are clickable only
      @selenium.find_element(:xpath, "//div[@id='store_deals']/div[1]/ul/li[1]").enabled?.should == true
      @selenium.find_element(:xpath, "//div[@id='store_deals']/div[1]/ul/li[3]").enabled?.should == true
    end
  
    it "Verify deal site info test(paragraph) exists under heading Dell Home Coupons and Deals" do
      @selenium.find_element(:id, "ctl00_ctl00_MainContent_PageContent_PromoContent").displayed?.should be == true
    end
  end
  
  describe "Verify for NEWEST COUPONS block" do
    it "Verify NEWEST COUPONS block exists" do
      #Newest coupons block doesn't exists on this page
    end
  
    it "Verify coupons exist" do
      #Newest coupons block doesn't exists on this page
    end
  
    it "Verify when clicked on the coupon code, user must be redirected to deals actual sites page" do
      #Newest coupons block doesn't exists on this page
    end
  end 
  
  describe "Verify for NEWEST DELL HOME DEALS section below featured deals" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify Deals are listed in NEWEST DELL HOME DEALS (default) section below featured deals in List View (default)" do
      @selenium.find_element(:css,".deal-list.list-view").displayed?.should be == true   
      #To check that Deals are listed in List view format(default) by checking list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
    end
  
    it "Verify button to change display from List view to Grid view (for NEWEST DELL HOME DEALS) redisplays deals in grid view" do
      @selenium.find_element(:css, ".grid-btn a").click
      #To check grid view button is active
      @selenium.find_element(:css, ".grid-btn a").attribute("class").should be == "active"
    end
  
    it "Verify button to change display back to List View works and redisplays deals in list view " do
      @selenium.find_element(:css, ".list-btn a").click
      #To check list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
    end
   
    it "Verify pagination exists and when clicked user is redirected to clicked page number" do
      @lib_obj.pagination("//div[@class='newest-deals']/ul/li[1]/div/div/div[2]/h2/a")
    end
  
    it "Verify for first product, when clicked on product name or image it redirects user to Deal Detail page" do
      #To check for product name
      href_val = "#{@base_url}" + @doc.xpath("//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/ul/li[1]/div/div/div/h2/a").attribute("href")
      #href_val = @selenium.find_element(:xpath, ".//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/ul/li[1]/div/div/div/h2/a").attribute("href")
      @selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/ul/li[1]/div/div/div/h2/a").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
  
      #To check for image          
      @selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/ul/li[1]/div/div/a/img").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
  
    it "Verify for first product when clicked on Get Deal link is redirects user to deals page of the actual deal website" do
      @lib_obj.response_code_is_302("//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[1]")
    end

    it "Verify Button to Change sort order to Hot changes title to HOTTEST DELL HOME DEALS" do
      @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_DealListControl_LinkButton2>img").click
      #@selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[3]/a").click
      sleep 3 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:css, ".deal-heading>h2").text.should be == "HOTTEST DELL HOME DEALS"
      #@selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/div/h2").text.should be == "HOTTEST DELL HOME DEALS" 
    end
  
    it "Verify Button to Change sort order to Expiring changes title to EXPIRING DELL HOME DEALS" do
      @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_DealListControl_LinkButton3>img").click
      #@selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[4]/a").click
      sleep 3 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:css, ".deal-heading>h2").text.should be == "EXPIRING DELL HOME DEALS"
      #@selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/div/h2").text.should be == "EXPIRING DELL HOME DEALS"
    end
  
    it "Verify Button to Change sort order to Editors Choice changes title to EDITORS CHOICE DELL HOME DEALS'" do
      @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_DealListControl_LinkButton4>img").click
      #@selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[5]/a").click
      sleep 3 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:css, ".deal-heading>h2").text.should be == "EDITORS' CHOICE DELL HOME DEALS"
      #@selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/div/h2").text.should be == "EDITORS' CHOICE DELL HOME DEALS"
    end
  
    it "Verify Button to Change sort order to Price changes title to LOWEST PRICED DELL HOME DEALS" do
      @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_DealListControl_LinkButton5>img").click
      #@selenium.find_element(:xpath, "//ul[@id='new-hot-choice']/li[6]/a").click
      sleep 3 # Required to load the header 
      #To check that title changes
      @selenium.find_element(:css, ".deal-heading>h2").text.should be == "LOWEST PRICED DELL HOME DEALS"
      #@selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_upActivedeals']/div/div/div/h2").text.should be == "LOWEST PRICED DELL HOME DEALS"
    end 
  end # Descibe ends for NEWEST DELL HOME DEALS
  
  describe "Verify for RECENTLY-EXPIRED DELL HOME DEALS section" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify expired deals are listed in RECENTLY-EXPIRED DELL HOME DEALS (default)" do
      for i in 1..@doc.xpath("//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li").size
      #for i in 1..@selenium.find_elements(:xpath,".//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li").size
        @selenium.find_element(:xpath,"//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li[#{i}]").displayed?.should be == true   
      end
      #To check that Deals are listed in List view format(default) by checking list view button is active
      @selenium.find_element(:css, ".list-btn a").attribute("class").should be == "active"
      #@selenium.find_element(:xpath, "//div[@id='filter_links']/ul/li[2]/a").attribute("class").should be == "active"
    end
  
    it "Verify for first product when clicked on product name or image it redirects user to Deal Detail page" do
      #To check for product name
      href_val = "#{@base_url}" + @doc.xpath("//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li[1]/div/div/div[2]/h2/a").attribute("href")
      @selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li[1]/div/div/div[2]/h2/a").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
  
      #To check for image          
      @selenium.find_element(:xpath, "//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li[1]/div/div/a/img").click
      @selenium.current_url.should include "#{href_val}"
      @selenium.navigate.back
      @lib_obj.waitforpagetoload  
    end
  
  it "Verify for first product when clicked on Get Deal link is redirects user to deals page of the actual deal website" do 
      @lib_obj.response_code_is_302("//*[@id='ctl00_ctl00_MainContent_PageContent_ExpiredDealsControl_pnlContainer']/div/ul/li[1]/div/div[2]/div[@class='dealbtn']/a[1]")
    end
  end  # Descibe ends for RECENTLY-EXPIRED DELL HOME DEALS
  
  it "Verify deal sites instructions text(paragraph) exists under heading DELL HOME DEALS INSTRUCTIONS" do 
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_Instructions>p").displayed?.should == true
  end

  it "Verify Hottest Daily Deals Widget exists on Right Rail" do 
    @Template.top_10_Deals_Widget_RightRail
  end

  it "Verify Latest Stories Widget exists on Right Rail" do 
    @Template.latest_Story_Widget_RightRail
  end
  
  it "Verify Page title is correct" do 
    @selenium.title.should == "Dell Home Coupons & Deals: Coupon Codes For Dell Home | Store | LogicBUY"
  end
  
  it "Verify Header exists" do 
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do 
    @Template.getFooter.displayed?.should == true 
  end 
end # Describe end
