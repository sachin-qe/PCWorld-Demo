require "rake"
require "selenium-webdriver"
require "rest-client"
require "rspec"
require "rubygems"
require "spec_helper"
require "yaml"

# a = ENV['module']
# Dir[File.dirname(__FILE__) + '/../pages/' + a + '/TemplatePage.rb'].each {|file| require file }

class Function_Library 

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

  def navigateback
    @driver.navigate.back
    waitforpagetoload
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
