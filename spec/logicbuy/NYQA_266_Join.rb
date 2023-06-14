require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"

describe "Verify Join link on homepage", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it Goes to correct url" do
    href_val = @Nokogiri.getAttribute("css",".join_btn","href")
    @lib_obj.clickandwait(@selenium.find_element(:css,".join_btn")) 
    @selenium.current_url.should include href_val
  end
  
  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Join form exists" do
    @selenium.find_element(:css, "div.content_info").displayed?.should == true
  end
  
  it "Verify Captcha image exists" do
    @selenium.find_element(:css, "#recaptcha_area").displayed?.should be == true
    @selenium.find_element(:css, "#recaptcha_challenge_image").displayed?.should be == true
  end
  
  it "Verify General validations are working for the form fields" do
    @lib_obj.clickandwait(@selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_Join_btn"))
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_reqUsernametxt").displayed?.should be == true
    @Nokogiri.verifyText("css","#ctl00_ctl00_MainContent_PageContent_reqUsernametxt","Please enter a Username")
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_reqEmailtxt").displayed?.should be == true
    @Nokogiri.verifyText("css","#ctl00_ctl00_MainContent_PageContent_reqEmailtxt","Please enter an Email Address")
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_reqPass1").displayed?.should be == true
    @Nokogiri.verifyText("css","#ctl00_ctl00_MainContent_PageContent_reqPass1","Please enter a Password")
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_reqPass2").displayed?.should be == true
    @Nokogiri.verifyText("css","#ctl00_ctl00_MainContent_PageContent_reqPass2","Please retype your Password")
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_reqBirthday").displayed?.should be == true
    @Nokogiri.verifyText("css","#ctl00_ctl00_MainContent_PageContent_reqBirthday","Please enter your birthday")
  end
end # describe end
