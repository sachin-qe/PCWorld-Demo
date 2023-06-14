require 'rake'
require "selenium-webdriver"
require "Function_Library"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify LogicBUY Homepage" ,:selenium => true do
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

  it "Verify that the response code is 200" do
    @lib_obj.waitforpagetoload
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify Featured Deals are shown at top of list" do
    @selenium.find_element(:id, "tabs-1").displayed?.should be_true
  end
  
  it "Verify Page is populated with search results by category" do
    @selenium.find_element(:class, "newest-deals").displayed?.should be_true
    @selenium.find_element(:class, "deal-heading").text.should_not == nil
  end
  
  it "Verify that Link for See All for First category brings you to the category page" do
    #@wait.until{ @selenium.find_element(:xpath, "//div[@class='see-all']/a").displayed? == true } 
    href_val = @selenium.find_element(:css, ".see-all a").attribute('href')
    #href_val = @selenium.find_element(:xpath, "//div[@class='see-all']/a").attribute('href')
    @selenium.find_element(:css, ".see-all a").click
    #@selenium.find_element(:xpath, "//div[@class='see-all']/a").click
    @lib_obj.waitforpagetoload
    @selenium.current_url.should be == href_val
    @selenium.navigate.back
  end

  describe "Verify Header Exists" do
    it "Verify Email Signup works" do
      #@lib_obj.get_base_URL(@base_url)
      @lib_obj.waitforpagetoload
      #@selenium.execute_script("$('div.email_signup').hover();");
      @selenium.find_element(:class, "email_signup").click
      @wait.until{ @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[2]").displayed? == true }
      @selenium.find_element(:css, ".email_textbox").send_keys "abcd" + rand(10000).to_s + "@test.com"
      #@selenium.find_element(:xpath, "//div[@class='email_signup']/div/div/div/input").send_keys "abcd" + rand(500).to_s + "@test.com"
      @selenium.find_element(:id, "ctl00_ctl00_btnSignUp").click
      for i in 0..3
        sleep 0.5
        if((@selenium.find_element(:class, "email_success").text.include? "Thank you for Subscribing.") == true)
          print "in if"
            @selenium.find_element(:class, "email_success").text.should == "Thank you for Subscribing."
            break
        end
      end
    end
    
    it "Verify Join redirects to correct url" do
      @wait.until { @selenium.find_element(:class, "join_btn").displayed? == true }
      href_val = @selenium.find_element(:class, "join_btn").attribute('href')
      @selenium.find_element(:class, "join_btn").click    
      @selenium.current_url.should  == href_val
      @selenium.navigate.back
    end
    
    it "Verify Login popup works" do
      @wait.until{ @selenium.find_element(:xpath, "//div[@id='user_container']/div/a[3]").displayed? == true }
      @selenium.find_element(:xpath, "//div[@id='user_container']/div/a[3]").click
      @wait.until { @selenium.find_element(:xpath, "//div[@id='ctl00_ctl00_Panel_Login']/div[2]").displayed? == true }
      @selenium.find_element(:css, ".modalLogin_body a").click
      #@selenium.find_element(:xpath, "//div[@class='modalLogin_body']/a").click
      @selenium.find_element(:xpath, "//div[@id='ctl00_ctl00_Panel_Login']/div[2]").displayed?.should be == false
    end  
  end

  it "Verify Top Ad" do
    @selenium.find_element(:id, "entry-ad").displayed?.should == true
  end
  
  it "Verify Header exists" do 
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do 
    @Template.getFooter.displayed?.should == true 
  end 
  
  it "Verify Bottom Ad" do
    @selenium.find_element(:class, "dartAd").displayed?.should == true
  end
  
  it "Verify Top 10 Deals Widget shows in Right Rail" do
    @Template.top_10_Deals_Widget_RightRail
  end
  
  it "Verify Latest Coupon Widget shows in Right Rail" do
    @Template.latest_Coupon_Widget_RightRail
  end
  
  it "Verify Latest Story Widget shows in Right Rail" do
    @Template.latest_Story_Widget_RightRail
  end
  
  it "Verify Search Bar Functionality" do
    @selenium.find_element(:css, "#search_field input").send_keys "Dell"
    #@selenium.find_element(:xpath, "//div[@id='search_field']/input").send_keys "Dell"
    # sleep 2
     @selenium.execute_script("document.getElementById('LoginPanel').scrollIntoView()")
    element = @selenium.find_element(:css, "#ctl00_ctl00_Search")
    @selenium.execute_script("arguments[0].click()",element)
    sleep 5
    # @lib_obj.waitforpagetoload
    @selenium.current_url.should == "#{@base_url}/search/dell"
    @selenium.navigate.back
  end
end # Describe end