require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Featured Deals area of Home Page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
  end  
  
  it "Verify page response code is 200" do
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify atlease one product is displayed below the menu as featured deal" do
    @lib_obj.waitforpagetoload
    @selenium.find_element(:id, "tabs-1").displayed?.should be_true
  end

  describe "Verify Featured Deals area" do
    it "Verify for main product that Title, Price, Hotness Meter, and Get Deal link exist" do
      @selenium.find_element(:xpath, "//div[@id='tabs-1']/div[2]/h3/a").displayed?.should be == true
      @Nokogiri.getText("xpath", "//div[@id='tabs-1']//a").should_not be == nil
      @selenium.find_element(:xpath, "//div[@class='price-box']/div[2]/span").displayed?.should be == true
      @Nokogiri.getText("xpath", "//div[@class='price-box']/div[2]/span").should_not be == nil
      @selenium.find_element(:id, "HotnessMeter").displayed?.should be == true
      @selenium.find_element(:xpath, "//div[@class='get-deal-div']/a").displayed?.should be == true
    end
    
    it "Verify for first product, when clicked on product name and image, it should redirect to clicked products deal page" do
      #Verify for Product image
      @lib_obj.waitforpagetoload
      href_val = @selenium.find_element(:xpath, "//div[@id='tabs-1']/div/a").attribute("href").to_s
      @selenium.find_element(:xpath, "//div[@id='tabs-1']/div/a/img").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == "#{href_val}"
      @selenium.navigate.back
      
      #Verify for Product name
      @lib_obj.waitforpagetoload
      href_val1 = @selenium.find_element(:xpath, "//div[@id='tabs-1']/div[2]/h3/a").attribute("href").to_s
      @selenium.find_element(:xpath, "//div[@id='tabs-1']/div[2]/h3/a").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == "#{href_val1}"
      @selenium.navigate.back
    end
    
    it "Verify when Get Deal link is clicked, the user is redirected to the product page on the merchants site" do
      @lib_obj.waitforpagetoload
      #Passing xpath for Get Deal link
      @lib_obj.response_code_is_302("//div[@class='get-deal-div']/a")
    end 
    
    it "Verify when the store name is clicked, the user is redirected to the store page on Logicbuy" do
      @lib_obj.get_Base_URL
      @lib_obj.waitforpagetoload
      href_val = @Nokogiri.getAttribute("xpath","//div[@class='get-deal-div']/a[2]","href")
      @selenium.find_element(:xpath, "//div[@class='get-deal-div']/a[2]").click
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == "#{@base_url}#{href_val}"
      @selenium.navigate.back
    end

    it "Verify when the 3rd thumbnail is clicked (below the main product) that the main deal is swapped for the new deal" do
      @lib_obj.waitforpagetoload
      @selenium.find_element(:xpath, "//div[@class='carousel-deal-list']/ul/li[3]/a/div").click
      sleep 2
      @selenium.find_element(:xpath, "//div[@id='tabs-3']").displayed?.should be == true
    end
  end
end #describe end