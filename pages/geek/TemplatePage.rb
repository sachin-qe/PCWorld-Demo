require 'rake'
require "selenium-webdriver"
require "spec_helper"
require "open-uri"
require "rspec"
require "Nokogiri_Library"
load "Function_Library.rb"


class TemplatePage < Function_Library  

  def initialize(driver)
    @lib_obj=Function_Library.new
    @driver=driver   
  end 
  
  def set_driver(driver)
    @lib_obj=Function_Library.new
    @driver = driver
  end 

  def getTopMenu(menuName)
    @driver.find_element(:xpath,".//a[@title='#{pageName}']/..")
  end

  def openTopMenu(menuName)
    getTopMenu(menuName).find_element(:css,"a").click
  end

  def openSubMenu(menuName,subMenuName)
    getTopMenu(menuName).find_element(:css,"a[title='#{subMenuName}']").click   
  end

  def openHomePage
     @driver.find_element(:css,".logo img").click
     @lib_obj = Function_Library.new
     @lib_obj.waitforpagetoload  
  end

  def getHeader
    return @driver.find_element(:css,"header")
  end

  def getFooter
    return @driver.find_element(:css,"footer")
  end

  def infinite_scroll
    for i in 1..10
      @driver.execute_script("window.scrollTo(0,document.body.scrollHeight);")
      sleep 1
    end
  end

  def top_link_check
    @driver.execute_script("document.getElementById('outbrain_widget_1').scrollIntoView()")
    element = @driver.find_element(:css, "div.top>a")
    # Required since element to be clicked gets overlapped by Page Header
    scroll_point = element.location.y - 200
    if(@browser == "chrome")
      location_before = @driver.execute_script("return window.scrollY;")
    else
      location_before = @driver.execute_script("return document.documentElement.scrollTop")
    end
    @driver.execute_script("window.scrollTo(0, #{scroll_point});")
    @driver.find_element(:css,"div.top>a").displayed?.should == true
    @driver.find_element(:css,"div.top>a").click
    if(@browser == "chrome")
      location_after = @driver.execute_script("return window.scrollY;")
    else
      location_after = @driver.execute_script("return document.documentElement.scrollTop") 
    end
    location_after.should < location_before
  end

  def leftpanel_widget_displayed
    # Verify Follow us is displayed 
    @driver.find_element(:css,"#execphp-5").displayed? == true
    
    # Deal of the day exists 
    @driver.find_element(:id, "logicbuy_first_deal-2").displayed?.should == true

    # Geek Newsletter block exists
    @driver.find_element(:id, "newsletter_signup-2").displayed?.should == true

    # More Geek block exists
    @driver.find_element(:id, "more_posts_by_category-2").displayed?.should == true
  end

  def next_previous_at_top
    @driver.find_element(:css,"div.pagenationtop>div.previous>a").displayed? == true
    @driver.find_element(:css,"div.pagenationtop>div.next>a").displayed? == true
  end

  # Next and previous article link at the bottom
  def next_previous_at_bottom
    @driver.find_element(:css,"div.paginationbottom>div.previous>a").displayed? == true
    @driver.find_element(:css,"div.paginationbottom>div.next>a").displayed? == true
    @driver.find_element(:css,"div.top").displayed? == true
  end

  def check_outbrain_module
    # Check "You Might Also Like" module exists
    @driver.find_element(:id, "outbrain_widget_0").displayed?.should == true
    
    # Check "We Recommend" module exists
    @driver.find_element(:class, "ob_dual_right").displayed?.should == true
    
    # Check "From Around the Web" module exists
    @driver.find_element(:class, "ob_dual_left").displayed?.should == true
  end

  def check_disqus_comment_section
    # Check disqus comment section exists
    @driver.find_element(:css, "div#disqus_thread").displayed?.should == true
  end
end
