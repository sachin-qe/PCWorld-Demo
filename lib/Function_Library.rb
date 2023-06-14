require "rake"
require "selenium-webdriver"
require "rest-client"
#require "pathconfig"
require "rspec"
require "rubygems"
require 'nokogiri'
require 'open-uri'
require "win32ole"
require "spec_helper"
require "Nokogiri_Library"
require "yaml"

a = ENV['module']
Dir[File.dirname(__FILE__) + '/../pages/' + a + '/TemplatePage.rb'].each {|file| require file }

class Function_Library < Nokogiri_Library

  def initialize
    @wait = set_timeout(30)
  end

  def set_driver(driver)
    @driver = driver
  end 
  
  def path_setup
    @tagname=ENV['module'] + '_' + ENV['env']
    @config = loadFile(File.dirname(__FILE__) + "/../config/Environment.yml",@tagname)
  end

  def sauce_url
    "http://zifftech:dee3b68d-43e4-445a-91ae-2b7bb0c70af8@ondemand.saucelabs.com:80/wd/hub"
  end

  def loadFile(filepath,tagname)
     configs = YAML.load_file(filepath)
     return configs[tagname]     
  end

  def browser_setup(platform_name, browser_name)
    $browser = browser_name
    platform = platform_name
    if($browser != "headless")
      if(platform == "local")
        if($browser.include?("ie") == true)
          @driver  = Selenium::WebDriver.for:internet_explorer
        elsif($browser == "chrome")
          @driver  = Selenium::WebDriver.for:chrome
        else
          @driver  = Selenium::WebDriver.for:firefox
        end
      else
      @platform_config = loadFile(File.dirname(__FILE__) + "/../config/Platform.yml",ENV['platform'])
      @url = "http://#{@platform_config['server']}:#{@platform_config['port']}/wd/hub"
        if($browser.include?("ie") == true)
          @caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
          @driver = Selenium::WebDriver.for(:remote, :url => @url, :desired_capabilities => @caps)
        elsif($browser == "chrome")
          @caps = Selenium::WebDriver::Remote::Capabilities.chrome
          @driver = Selenium::WebDriver.for(:remote, :url => @url, :desired_capabilities => @caps)
        else
          @caps = Selenium::WebDriver::Remote::Capabilities.firefox
          @driver = Selenium::WebDriver.for(:remote, :url => @url, :desired_capabilities => @caps)
        end
      end

      @driver.manage.window.maximize
      @config = path_setup
      @base_url = "http://#{@config['baseurl']}"
      open_base_URL(@base_url)
      return @driver
    end
  end

  def open_homepage
   @page = TemplatePage.new(@driver)
   @page.openHomePage
  end
  
  def set_timeout(set_time)
    @time = set_time
    @wait = Selenium::WebDriver::Wait.new(:timeout => @time)  
    return @wait
  end 

  def getWait
    return set_timeout(30)
  end
  
  def mousehover(locator,value)
    getWait.until { @driver.find_element(locator,value).displayed? == true }
    @element = @driver.find_element(locator,value)
    @driver.action.move_to(@element).perform
    sleep 1
  end


  def get_Base_URL
    @config = path_setup
    @base_url = "http://#{@config['baseurl']}"
    return @base_url
  end

  def open_base_URL(base)
   @driver.get(base)
   @page = TemplatePage.new(@driver)
   @page.openHomePage
  end

  def waitforpagetoload
    begin
      getWait.until{@driver.execute_script("return jQuery.active")==0}      
    rescue
    end
  end

  def clickandwait(element)
    element.click
    waitforpagetoload
  end

  def ad_handle
    # Close prestitial ad if it exists
    begin
      getWait.until { @driver.find_element(:xpath, "//div[contains(@id, 'CM8SkipContainer_')]") }
      @driver.find_element(:xpath, "//div[contains(@id, 'CM8SkipContainer_')]").click
    rescue Exception => e
    end
  end
  
  def ipad_overlay_handle 
    @driver.find_element(:link_text,"No Thanks").click
  end

  # To Verify Response code
  def verify_response_code(code) 
     uri = URI.parse(@driver.current_url)
     http = Net::HTTP.new(uri.host, uri.port)
     request = Net::HTTP::Get.new(uri.request_uri)
     response = http.request(request)
      if (response.code == "#{code}")
        return true
      else
        return false
      end
  end

  # To Check Page header
  def check_page_header
    status = @driver.find_element(:id, "header-div").displayed?
    # status = @driver.find_element(:css,"#top-header").displayed?
    return status
  end

  # To Check Page footer  
  def check_page_footer
    status = @driver.find_element(:id,"footer").displayed?
    # status = @driver.find_element(:css,"#pcm-footer").displayed?
    return status
  end

  def check_disqus_comment_section
    @driver.find_element(:css, "#disqus_thread").displayed?.should == true
  end
  
  def navigateback
    @driver.navigate.back
    waitforpagetoload
  end
  
  def check_ads_display(frame_id, data_width, data_height)
    @driver.find_element(:id, "#{frame_id}").displayed?.should == true
    @driver.find_element(:id, "#{frame_id}").attribute("data-width").should == "#{data_width}"
    @driver.find_element(:id, "#{frame_id}").attribute("data-height").should == "#{data_height}"
  end

  def check_attribute_adtag(id_path, tag_name)
    if(@driver.find_element(:id, "#{id_path}").attribute("src").to_s.include?("#{tag_name}") == true)
      return true
    else
      return false
    end
  end

  def check_outbrain_module
    # Check "You Might Also Like" module exists
    @driver.find_element(:css, "#outbrain_widget_0").displayed?.should == true
    
    # Check "We Recommend" module exists
    @driver.find_element(:css, ".ob_dual_right").displayed?.should == true
    
    # Check "From Around the Web" module exists
    @driver.find_element(:css, ".ob_dual_left").displayed?.should == true
  end
  
  def readJSONresponse(json_string)
    begin
      return JSON.parse(open(json_string).read).to_s
    rescue Exception => e#.message("not able to parse string "+json_string)
    end
  end
  
  def response_code_is_302(xpath_val)
    @doc = Nokogiri::HTML(open(@driver.current_url))
    deal_id = @doc.xpath("#{xpath_val}").attribute("data-deal-id")
    href_val = "#{@base_url}" + @doc.xpath("#{xpath_val}").attribute("href")
    href_val.to_s.include?(deal_id).should == true
    #Checking for Response code
    response = Net::HTTP.get_response(URI.parse(href_val))
    response.code.should == "302"
  end
  
  def page_response_code
    response = Net::HTTP.get_response(URI.parse(@driver.current_url))
    if (response.code == '200')
      return true
    else
      return false
    end
  end
  
  def pagination(xpath_val)
    # To count no. of pages
    @doc = Nokogiri::HTML(open(@driver.current_url))       
    #temp = @doc.xpath("//div[@class='pagerclass']/a").size-1    
    #temp = @driver.find_elements(:xpath,"//div[@class='pagerclass']/a").size-1
    no_of_page = @doc.at_css("a[id$='last']").text.to_i     
    #no_of_page = @doc.xpath("//div[@class='pagerclass']/a[#{temp}]").text.to_i
    #no_of_page = @driver.find_element(:xpath, "//div[@class='pagerclass']/a[#{temp}]").text.to_i
    # Range for clicking 'next or previous' button is one less than no. of page
    range = no_of_page - 1
    # To check for ascending pagination 
    for i in 1..range
      # To click on next
      @driver.find_element(:class,"pagerclass").find_element(:link_text, "#{i}").attribute("class").should == "pagerLinkSel"
      string1 = @driver.find_element(:xpath, "#{xpath_val}").text
      @driver.find_element(:class,"pagerclass").find_element(:css,"a[id$='next']").click
      #@driver.find_element(:class,"pagerclass").find_element(:link_text, "Next »").click
      sleep 4 #Required to get page load completely
      string2 = @driver.find_element(:xpath, "#{xpath_val}").text
      #To check that page is changed
      string1.should_not == string2
    end
  
    # To check for descending pagination
    for i in (range).downto(1)
      # To click on next
      @driver.find_element(:class,"pagerclass").find_element(:link_text, "#{i+1}").attribute("class").should == "pagerLinkSel"
      string1 = @driver.find_element(:xpath, "#{xpath_val}").text
      @driver.find_element(:class,"pagerclass").find_element(:css,"a[id$='prev']").click  
      #@driver.find_element(:class,"pagerclass").find_element(:link_text, "« Previous").click
      sleep 4 #Required to get page load completely
      string2 = @driver.find_element(:xpath, "#{xpath_val}").text
      #To check that page is changed
      string1.should_not == string2
    end
  end

  def selectDropdownOption(dropdownelement,texttoselect)
    option = Selenium::WebDriver::Support::Select.new(dropdownelement)
    option.select_by(:text, texttoselect)
    # @selenium.find_element(:css,"input[type='button']").click
    # getWait.until{@selenium.find_element(:css,"input[name='title']").displayed? == true}
  end

  def verify_response_code_RestClient(code)
     response = RestClient.get(@driver.current_url)
     if (response.code == "#{code}")
        return true
      else
        return false
      end
  end

  def waitforelement(element)
    getWait.until{element.displayed? == true}
  end
end # Class end
