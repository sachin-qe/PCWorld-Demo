require "rake"
require "selenium-webdriver"
require "Function_Library"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Deal Alerts page", :selenium => true do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @Template = TemplatePage.new(@selenium) 
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_base_URL(@base_url)
  end
  
  it "Verify that if user is not logged in then user should be navigated to login page" do
    @lib_obj.waitforpagetoload
    @selenium.execute_script("document.getElementById('lb-footer').scrollIntoView()")
    @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[2]/ul/li[3]/a").click
    @selenium.current_url.should be == "#{@base_url}/login.aspx?ReturnUrl=%2fdealalerts.aspx"
    @wait.until{ @selenium.find_element(:id, "info_div").displayed? == true }
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_Login1_UserName").send_keys "test123"
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_Login1_Password").send_keys "test@123"
    @selenium.find_element(:css, "#ctl00_ctl00_MainContent_PageContent_Login1_LoginLinkButton").click
  end
  
  it "Verify that user is navigated to correct page after authentication" do
    @lib_obj.waitforpagetoload
    @selenium.current_url.should be == "#{@base_url}/dealalerts.aspx"
  end
  
  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200)
  end
  
  it "Verify Page title is correct" do
    @selenium.title.should be == "Deal Alerts | LogicBuy"
  end
  
  it "Verify the page heading DEAL ALERTS exists" do
    @selenium.find_element(:xpath, "//div[@id='info_div']/h2").displayed?.should be == true
    @selenium.find_element(:xpath, "//div[@id='info_div']/h2").text.should be == "DEAL ALERTS"
  end
  
  it "Verify the form exists with textboxes for Email Address and Keywords" do
    @selenium.find_element(:id, "info_div").displayed?.should be == true
    @selenium.find_element(:id, "info_div").displayed?.should be == true
    @selenium.find_element(:id, "info_div").displayed?.should be == true
  end  
  
  it "Verify user email address must be present in the Email Address text-box" do
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/div[2]/input").text.should_not be == nil
  end

  it "Verify client-side validations are working (blank field validations)" do
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/div[4]/input").send_keys ""
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/div[5]/a").click
    sleep 2 # Require for validation
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/div[4]/span[3]").text.should be == "Please enter Keywords"
  end
  
  it "Verify when clicked on submit the page reloads and confirmation message is shown to the user" do
    @selenium.navigate.refresh
    @lib_obj.waitforpagetoload
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/div[4]/input").send_keys "test"
    @selenium.find_element(:xpath, ".//*[@class='joincontainer']/div[5]/a").click
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/p[1]").displayed?.should be == true
    @selenium.find_element(:xpath, "//div[@class='joincontainer']/p[1]").text.should include "You have successfully registered for Deal Alerts. You should begin receiving emails soon."
  end
  
  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true 
  end
  
  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
end # describe end
