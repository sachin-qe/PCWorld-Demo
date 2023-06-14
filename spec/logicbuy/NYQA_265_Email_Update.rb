require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Email Update block on homepage", :selenium => true do
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
    
  it "Verify HTTP response is 200" do
    @lib_obj.waitforpagetoload
    @lib_obj.page_response_code.should == true
  end
  
  it "Verify Email Update expandable block exists in the header" do
    @selenium.find_element(:css, ".email_signup").displayed?.should be == true 
  end
  
  it "Verify On Mouse Hover it must expand" do
    @selenium.find_element(:css, ".email_signup").click
  end
    
  it "Verify that invalid email and blank space validations are working for the email textbox" do
    #Email field blank
    @wait.until{ @selenium.find_element(:css, ".email_signup div").displayed? == true }
    @selenium.find_element(:css, ".email_signup div div div input").send_keys " "
    @selenium.find_element(:css, ".email_signup div div div div").click
    @wait.until {@selenium.find_element(:css, ".email_signup").displayed? == true }
    @selenium.find_element(:css, ".email_signup").click
    sleep 2 #Required for email validation
    @selenium.find_element(:xpath, "//div[@class='validation']/span[2]").displayed?.should be == true
    @selenium.find_element(:xpath, "//div[@class='validation']/span[2]").text.should be == "Please enter a valid Email Address"
    @wait.until{ @selenium.find_element(:css, ".email_signup div").displayed? == true }
    #Invalid email
    @selenium.find_element(:css, ".email_signup div div div input").send_keys "abd@.com"
    @selenium.find_element(:css, ".email_signup div div div div").click
    @wait.until {@selenium.find_element(:css, ".email_signup").displayed? == true }
    @selenium.find_element(:css, ".email_signup").click
    sleep 2 #Required for email validation
    @selenium.find_element(:css, ".validation span").displayed?.should be == true
    @selenium.find_element(:css, ".validation span").text.should be == "Please enter a valid Email Address"
  end
  
  it "Verify When clicked on Terms of Use and Privacy Policy links the user must be redirected to clicked page" do
    #Click on Terms of Use
    @wait.until { @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[1]").displayed? == true }
    terms_of_use_text = @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[1]").text
    @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[1]").click
    @selenium.switch_to.window(@selenium.window_handles.last)
    @wait.until{ @selenium.find_element(:css, "h1").displayed? == true }
    @selenium.title.include?("Ziff Davis").should be == true
    @selenium.title.include?("#{terms_of_use_text}").should be == true
    @selenium.close
    @selenium.switch_to.window(@selenium.window_handles.first)

    #Click on Privacy Policy
    @lib_obj.waitforpagetoload
    @selenium.find_element(:css, ".email_signup").click
    @wait.until { @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[2]").displayed? == true }
    privacy_policy_text = @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[2]").text
    @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[2]").click
    @selenium.switch_to.window(@selenium.window_handles.last)
    @wait.until{ @selenium.find_element(:css, "h1").displayed? == true }
    @selenium.title.include?("Ziff Davis").should be == true
    @selenium.title.include?("#{privacy_policy_text}").should be == true
    @selenium.close
    @selenium.switch_to.window(@selenium.window_handles.first)
  end
  
  it "Verify When clicked on Submit button it must show an appropriate message" do
    @lib_obj.open_base_URL(@base_url)  
    @lib_obj.waitforpagetoload
    @selenium.find_element(:css, ".email_signup").click
    #sleep 2
    @wait.until { @selenium.find_element(:xpath, "//div[@class='email_signup_form']/div[2]/a[2]").displayed? == true }
    @selenium.find_element(:css, ".email_signup div div div input").send_keys "test" + rand(500).to_s + "@test.com"
    @selenium.find_element(:css, "#ctl00_ctl00_btnSignUp").click
    @selenium.find_element(:css, ".email_signup").click
    @selenium.find_element(:css, ".email_success").text.should be == "Thank you for Subscribing"
  end
end #Describe end
