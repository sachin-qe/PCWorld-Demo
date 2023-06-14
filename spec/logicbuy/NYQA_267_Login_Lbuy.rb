require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Login module on homepage", :selenium => true,:retry => 3 do
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
  
  it "Verify Login link must exists" do
    @lib_obj.waitforpagetoload
    @selenium.find_element(:css, "#LoginLink").click
    @wait.until { @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").displayed? == true }
  end
  
  describe "Verify Login module" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end

    it "Verify When clicked a popup should be displayed in the center of the page " do
      #Getting Height and Width of the popup
      popup_height = @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").size.height
      popup_width = @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").size.width
      #Getting Top,bottom, left and right distance from Window edge for popup window
      offset_array = @selenium.execute_script("elm=document.getElementById('ctl00_ctl00_Panel_Login');var r = elm.getBoundingClientRect(); arr_offset = new Array(r.left,r.right,r.top,r.bottom);return arr_offset;")
      left_offset = offset_array[0]
      right_offset = offset_array[1] - popup_width #Getting actual distance from right
      top_offset = offset_array[2]
      bottom_offset = offset_array[3] - popup_height #Getting actual distance from bottom
      left_offset.should be == right_offset
      top_offset.should be == bottom_offset
    end
    
    it "Verify general validations for Username and Password fields" do
      @selenium.find_element(:id, "ctl00_ctl00_Button_Login").click
      sleep 2 #Required enough time for error message to get displayed
      @selenium.find_element(:id, "ctl00_ctl00_RequiredFieldValidator2").displayed?.should be == true
      @selenium.find_element(:id, "ctl00_ctl00_RequiredFieldValidator1").displayed?.should be == true
    end
    
    it "Verify when clicked on Close sign or anywhere else on page, the popup should get closed" do
      @selenium.find_element(:id, "ctl00_ctl00_Button_Cancel").click
    end
    
    it "Verify Join link exists When clicked it should redirect to Join page" do
      @lib_obj.open_base_URL(@base_url)
      @wait.until { @selenium.find_element(:css, "#LoginLink").displayed? == true }
      @selenium.find_element(:css, "#LoginLink").click
      @wait.until { @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").displayed? == true }
      @selenium.find_element(:xpath, "//div[@class='modalLoginBox']/div[3]/a").displayed?.should be == true
      link_href = @doc.at("//div[@class='modalLoginBox']/div[3]/a")["href"]
      @selenium.execute_script("window.open('#{link_href}','_self')")
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == "#{@base_url}/join.aspx"   
    end
    
    it "Verify Forgot you username or password link exists When clicked it should redirect to login page" do
      @lib_obj.open_base_URL(@base_url)
      @wait.until { @selenium.find_element(:css, "#LoginLink").displayed? == true }
      @selenium.find_element(:css, "#LoginLink").click
      @wait.until { @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").displayed? == true }
      @selenium.find_element(:css, "div.login_text > a").displayed?.should be == true
      link_href = @doc.at_css("div.login_text > a")["href"]
      @selenium.execute_script("window.open('#{link_href}','_self')")
      @lib_obj.waitforpagetoload
      @selenium.current_url.should be == "#{@base_url}/login.aspx"
    end
    
    it "Verify when clicked on login button after entering valid credentials the user should get login" do
      @lib_obj.open_base_URL(@base_url)
      @wait.until { @selenium.find_element(:css, "#LoginLink").displayed? == true }
      @selenium.find_element(:css, "#LoginLink").click
      @wait.until { @selenium.find_element(:id, "ctl00_ctl00_Panel_Login").displayed? == true }
      @selenium.find_element(:css, "#ctl00_ctl00_TextBox_Username").send_keys "test123"
      @selenium.find_element(:css, "#ctl00_ctl00_TextBox_Password").send_keys "test@123"
      @selenium.find_element(:id, "ctl00_ctl00_Button_Login").click
      sleep 5# Sleep is Required to for verification 
      # @selenium.switch_to.window(@selenium.window_handles.last)
      @lib_obj.waitforpagetoload
      @selenium.find_element(:id, "user").text.should be == "test123"
    end 
  end
end # describe end
