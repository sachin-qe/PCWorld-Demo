require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Latest Coupons widget on homepage" ,:selenium => true do
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
  
  it "HTTP response is 200" do
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify by default 6 coupons should be displayed with their store image,name,Coupon Code,and expiration" do
    @selenium.find_elements(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li").size.should == 6
    for i in 1..6
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li[#{i}]").displayed?.should == true
      #To check for store image
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li[#{i}]/img").displayed?.should == true
      #To check for name
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li[#{i}]/div[@class='coupon_title']").displayed?.should == true
      #To check for Coupon Code
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li[#{i}]/div[@class='coupon_code']").displayed?.should == true
      #To check for expiration
      @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/ul/li[#{i}]/div[@class='expire_date']").displayed?.should == true
    end
  end
  
  it "Verify when clicked on See All Coupons, it redirects user to the store list page" do
    #To click on 'See All Coupons'
    @selenium.find_element(:xpath, ".//*[@id='right_column_deals']/div[3]/a/img").click 
    @selenium.current_url.should be == "#{@base_url}/stores"
    @selenium.navigate.back 
    @wait.until { @selenium.find_element(:xpath, "//div[@id='lb-footer']").displayed? == true }
  end
  
  it "Verify for first coupon, when clicked, it redirects user to the store of the coupon (off LogicBuy) in a new window" do
    src_url = @selenium.find_element(:xpath, "//ul[@class='latest_coupons']/li").attribute('data-url')
    redirect_url = "#{@base_url}#{src_url}"
    response = Net::HTTP.get_response(URI.parse(redirect_url))
    response.code.should be == "302" # URL is permenantly redirected hence gives 301 code not 302
    response['location'].should_not == @base_url
  end
end