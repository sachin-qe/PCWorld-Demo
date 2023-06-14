require "rake"
require "selenium-webdriver"
require "net/http"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Content page", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @selenium.get "#{@base_url}/page/cheap-tv-deals"
  end

  it "Verify HTTP response is 200" do
    @lib_obj.page_response_code.should == true
  end
  
  describe "CHEAP TV DEALS" do
    before(:all) do
      @selenium.find_element(:id, "content_div").displayed?.should be == true
    end
    
    it "Verify description text exists under CHEAP TV DEALS section" do
      @selenium.find_element(:css, "div.content_info_about.giveaway_content").displayed?.should be == true
      @selenium.find_element(:css, "div.content_info_about.giveaway_content").text.should_not be == nil
    end
  end # describe end for Cheap TV deals
  
  describe "NEWEST HDTVS and HOME THEATER DEALS" do
    before(:all) do
      @selenium.find_element(:id, "ctl00_ctl00_MainContent_PageContent_upDeals").displayed?.should be == true
    end
    
    it "Verify Deals are listed in NEWEST HDTVS and HOME THEATER DEALS  section below featured deals in List View format" do
      @selenium.find_element(:css, "div.newest-deals ul.deal-list").displayed?.should be == true
      @selenium.find_element(:xpath, "//div[@id='filter_links']/ul/li[2]/a").attribute("class").should be == "active"
    end
    
    it "Verify Button to change display from List view to Grid view (for NEWEST HDTVS & HOME THEATER DEALS) redisplays deals in grid view" do
      @Template.grid_view_click
    end
    
    it "Verify Button to change display back to List View works and redisplays deals in list view" do
      @Template.list_view_click
    end
    
    it "Verify for first product, Hotness Meter exists" do
      @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_DealListControl_DealRepeater_ctl00_HotnessMeter_imgHotnessMeter").displayed?.should be == true
    end
    
    it "Verify for first product when clicked on product name and image it should redirect to clicked product deal page" do
      # Checking for product name
      @lib_obj.waitforpagetoload
      href_val1 = @selenium.find_element(:xpath, "//div[@class='list-view-div']/div/div[2]/h2/a").attribute("href")
      @selenium.find_element(:xpath, "//div[@class='list-view-div']/div/div[2]/h2/a").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == href_val1
      @selenium.navigate.back
      
      # Checking for image
      @lib_obj.waitforpagetoload
      @wait.until{ @selenium.find_element(:xpath, "//div[@class='list-view-div']/div/a/img").displayed? == true }
      href_val2 = @selenium.find_element(:xpath, "//div[@class='list-view-div']/div/a").attribute("href")
      @selenium.find_element(:xpath, "//div[@class='list-view-div']/div/a/img").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == href_val2
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
    
    it "Verify for first product when clicked on Get Deal link it redirects user to deal page of the clicked product website" do
       @lib_obj.response_code_is_302("//div[@class='dealbtn']/a")
    end
    
    it "Verify for the first product when clicked on the store link it redirects to the clicked stores LogicBuy page(you can found the store link just below the Get Deal link)" do
      href_val = @selenium.find_element(:xpath, "//div[@class='dealbtn']/a[2]").attribute("href")
      @selenium.find_element(:xpath, "//div[@class='dealbtn']/a[2]").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == href_val
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
    
    it "Verify pagination is working" do
      @lib_obj.pagination(".//*[@id='ctl00_ctl00_MainContent_PageContent_DealListControl_pnlContainer']/div[1]/ul/li[1]/div/div[1]/div[2]/h2/a")
    end
    
    it "Verify Sort Changes change label and sort values on all lists" do
      for i in 2..@selenium.find_elements(:xpath, "//div[@id='filter_links']/ul[2]/li").size
        @selenium.find_element(:xpath, "//div[@id='filter_links']/ul[2]/li[#{i}]/a").click
        sleep 3 # Require to give enough time for AJAX call
        if(i==2)
          @selenium.find_element(:xpath, "//div[@class='deal-heading']/h2").text.should == "NEWEST HDTVS & HOME THEATER DEALS"
        elsif(i==3)
          @selenium.find_element(:xpath, "//div[@class='deal-heading']/h2").text.should == "HOTTEST HDTVS & HOME THEATER DEALS"
        elsif(i==4)
          @selenium.find_element(:xpath, "//div[@class='deal-heading']/h2").text.should == "EXPIRING HDTVS & HOME THEATER DEALS"
        elsif(i==5)
          @selenium.find_element(:xpath, "//div[@class='deal-heading']/h2").text.should == "EDITORS' CHOICE HDTVS & HOME THEATER DEALS"
        else 
          @selenium.find_element(:xpath, "//div[@class='deal-heading']/h2").text.should == "LOWEST PRICED HDTVS & HOME THEATER DEALS"
        end
      end
    end
  end # describe end for NEWEST HDTVS & HOME THEATER DEALS
  
  it "Verify Page title is correct" do
    @selenium.title.should be == "Cheap TV Deals - Roundup | LogicBuy"
  end
  
  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
end #describe end

