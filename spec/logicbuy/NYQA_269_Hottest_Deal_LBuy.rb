require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Top 10 Hottest Daily Deals widget on homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_base_URL(@base_url)  
  end  

  it "Verify HTTP response is 200" do
    @lib_obj.page_response_code.should == true
  end

  describe "Verify Top 10 Hottest Daily Deals" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify by default 5 deals should be displayed with their product image name and Get Deal link" do
      for i in 1..@doc.at(".//*[@id='right_column_deals']/div[2]/ul").css("li").size
        if(i <= 5)	
  	  @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[#{i}]").displayed?.should == true
        else
  	  @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[#{i}]").displayed?.should == false
        end	
      end
    end

    it "Verify when clicked on SEE ALL 10 HOT DEALS the panel expands and displays 10 deals instead of 5 When clicked on Close link it should again display 5 deals" do
      #To check for see all 10 HOT DEALS
      @selenium.find_element(:xpath, ".//*[@class='hottest_deals_footer']/span").click	
      for i in 1..@doc.at(".//*[@id='right_column_deals']/div[2]/ul").css("li").size
        @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[#{i}]").displayed?.should == true
      end
      #To check for close
      @selenium.find_element(:xpath, ".//*[@class='hottest_deals_footer']/span").click	
      for i in 6..@doc.at(".//*[@id='right_column_deals']/div[2]/ul").css("li").size
        @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[#{i}]").displayed?.should == false
      end
    end

    it "Verify for first product when clicked on product name or image it redirects user to Deal Detail page" do
      #To check for product name
      $href_val = @doc.at(".//*[@id='right_column_deals']/div[2]/ul/li[1]/a")["href"]
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[1]/a").click
      @selenium.current_url.should include $href_val
      @selenium.navigate.back 
      @lib_obj.waitforpagetoload

      #To check for image           
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[2]/ul/li[1]/a/div[2]/img").click
      @selenium.current_url.should include $href_val  
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end

    it "Verify for first product when clicked on Get Deal link it redirects user to Deal Detail page" do
      @selenium.find_element(:xpath,".//*[@id='right_column_deals']/div[2]/ul/li[1]/div/a[2]").click
      @selenium.current_url.should include $href_val
      @selenium.navigate.back 
      @lib_obj.waitforpagetoload
    end
  end
end # describe end
