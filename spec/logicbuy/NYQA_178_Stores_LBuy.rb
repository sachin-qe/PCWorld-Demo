require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Stores link in header"  do
  before(:all) do
    @driver = RSpec.configuration.selenium
    @lib_obj=Function_Library.new
    @lib_obj.set_driver(@driver)
    @storespage=Stores.new(@driver,"Stores")
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it "Verify Should be able to click on STORES link" do
    @storespage.openPage 
  end

  it "Verify Goes to correct url " do
   @driver.current_url.should include "#{@lib_obj.get_Base_URL}" + "/stores"  
  end

  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify Most Popular stores are listed in subnav bar" do
    #To check that all stores are displayed
    @storespage.getMostPopularstores.size.should >= 1
  end

  it "Verify for the first link, when clicked user must be redirected to stores page" do
    #To check on first link
    element = @storespage.getMostPopularstores.first
    href_val = element.attribute("href")
    @lib_obj.clickandwait(element)
    @driver.current_url.should include "#{href_val}"
    @lib_obj.navigateback
  end

  it "Verify coupons are displayed in the block labeled Newest Coupons" do
    @storespage.getNewestCoupons.each do |coupon|
      coupon.displayed?.should == true
    end
  end

  # # it "Verify pagination works for Newest Coupons panel" do
  # #   #Pagination doesn't exists for this section
  # # end

  it "Verify for the first coupon when clicked it should redirect user to deals page of original deal website" do
    before_windowhandles = @driver.window_handles
    coupon_object = @storespage.getNewestCoupons.first.find_element(:css,"#coupon_body li object")
    value =  coupon_object.find_element(:xpath,".//param[2]").attribute("value").split("&")
    couponcode = value[2].split("=").last
    @driver.find_element(:css, "object[type='application/x-shockwave-flash']").click
    @driver.window_handles.size.should > before_windowhandles.size
    #Pasting copied coupon code in textbox
    @driver.find_element(:class, "search_term").send_keys [:control, 'v']
    #To check that page for same couponcode is opened
    @driver.find_element(:class, "search_term").attribute("value").should == couponcode
    @driver.navigate.refresh
  end
  
  it "Verify stores(image and name) are listed in the block labeled Stores" do
    @storespage.getStores.each do |store|
      # To check that is displayed
      store.find_element(:css,"a img").displayed?.should be == true
      #To check that name is displayed
      store.find_element(:xpath,".//a[2]").text.should_not be == nil
    end
  end

  it "Verify sort option per alphabets exists on the top of the Stores block" do
    #Compare letter's ascii value to check that all letters exists
    code = 65
    sort_options = @storespage.getSortOptions
    sort_options.values_at(2..sort_options.size-1).each do |option|
      option.find_element(:css,"a").text.ord.should == code
      code += 1
    end
  end

  it "Verify for one alphabet when clicked it should display only the stores starting with clicked alphabet" do
    #To click on alphabet 'A'
    @driver.execute_script("document.getElementById('pagination_alphabet').scrollIntoView()")
    @lib_obj.clickandwait(@driver.find_element(:id,"ctl00_ctl00_MainContent_PageContent_Pager_pager_ctl03_change"))
    @wait.until { @driver.find_element(:css,"#pagination_alphabet").find_element(:css,".pagerLinkSel").text.to_s == "A" }
     #To check that only the stores starting with 'A' are displayed
    @storespage.getStores.each do |store_option|
      store_option.find_element(:xpath,".//a[2]").text[0].should == 'A'
    end
    @driver.navigate.refresh
  end

  it "Verify when clicked on Store image or name, it redirects user to clicked stores page on LogicBuy" do
    #Considering first store
    #To scroll to the element to get clicked properly
    @driver.execute_script("document.getElementById('store_bg').scrollIntoView()")
    store = @storespage.getStores.first
    href_val =store.attribute("href").to_s
    @lib_obj.clickandwait(store.find_element(:xpath,".//a[2]"))
    @driver.current_url.should include "#{href_val}"
    @driver.navigate.back
    #To check for image
    @driver.execute_script("document.getElementById('store_bg').scrollIntoView()")
    store = @storespage.getStores.first
    @lib_obj.clickandwait(store.find_element(:css,"a img"))
    @driver.current_url.should include "#{href_val}"
    @driver.navigate.back
  end
  
  it "Verify Hottest Daily Deals Widget exists on Right Rail" do
    @storespage.getHottestDailyDeals.displayed?.should == true
  end

  it "Verify Latest Coupons Widget exists on Right Rail" do
    #Latest coupons widget does not exist on this page
  end

  it "Verify Latest Stories Widget exists on Right Rail" do
    @storespage.getLatestStoriesWidget.displayed?.should == true
  end

  it "Verify Page title is correct" do
    @driver.title.should == "Coupons & Deals By Stores | LogicBuy"
  end

  it "Verify Header exists" do
    @storespage.getHeader.displayed?.should be == true  
  end

  it "Verify Footer exists" do
    @storespage.getFooter.displayed?.should be == true
  end
end # Describe end