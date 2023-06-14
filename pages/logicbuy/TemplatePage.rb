require 'rake'
require "selenium-webdriver"
require "spec_helper"
require "open-uri"
require "rspec"
require "Function_Library"

class TemplatePage

  def initialize(driver)
    @lib_obj = Function_Library.new
    @driver = driver
    @wait = @lib_obj.set_timeout(30)
  end 

  def getTopMenuContainer
    return @driver.find_element(:css,"#main_nav")
  end

  def getTopMenu(menuName)
    $menu=menuName
    menu = ".//a[@title='" + menuName + "']/.."    
    return @driver.find_element(:xpath,menu)
  end

  def getSubMenu    
    return getTopMenu($menu).find_element(:css,".dropdown")
  end

  def openTopMenu(menuName)
    @lib_obj.clickandwait(getTopMenu(menuName).find_element(:css,"a"))
  end

  def openSubMenu(subMenuName)
    @lib_obj.clickandwait(getSubMenu.find_element(:css,"a[title='#{subMenuName}']"))
  end

  def openHomePage
      @driver.find_element(:css,"#logic_logo a").click
      @lib_obj.waitforpagetoload  
  end

  def getBreadCrumbs
      return @driver.find_element(:css,".deal_breadcrumbs")
  end

  def getFeartureDeal
      return @driver.find_element(:css,".featured-deal")
  end

  def getFeartureDealHeader
      return getFeartureDeal.find_element(:css,"h1")
  end

  def getFeartureDealHeaderText
      return getFeartureDeal.find_element(:css,".featured-content")
  end

  def getFeartureDeals
      return getFeartureDeal.find_elements(:css,"ul li")
  end

  def getHeader
    return @driver.find_element(:css,"#header")
  end

  def getFooter
    return @driver.find_element(:css,"#footer")
  end

  def getLatestStoriesWidget
    return @driver.find_element(:css,".recent_features ")  
  end

  def getHottestDailyDeals
    return @driver.find_element(:css,".hottest_deals")
  end
   
  def grid_view_click
    @wait.until{@driver.execute_script("return jQuery.active")==0}
    #@wait.until{ @driver.find_element(:css,".grid-btn a").displayed? == true }
    @driver.find_element(:css,".grid-btn a").click
    #To check grid view button is active
    @driver.find_element(:css,".grid-btn a").attribute("class").should == "active"
  end
  
  def list_view_click
    @wait.until{@driver.execute_script("return jQuery.active")==0} 
    #@wait.until{ @driver.find_element(:css,".list-btn a").displayed? == true }
    @driver.find_element(:css,".list-btn a").click
    #To check grid view button is active
    @driver.find_element(:css,".list-btn a").attribute("class").should == "active"
  end
  
  def top_10_Deals_Widget_RightRail
    begin
      if (@driver.find_element(:css, ".hottest_deals").displayed? == true)
        @doc = Nokogiri::HTML(open(@driver.current_url))
        @doc.css(".hottest_deals li").size.should > 0
      end
    rescue Exception => e
      @driver.save_screenshot("Z:/Screenshots_test/Top_10_Deals_Widget_"+ Time.now.strftime("%d-%m-%s %Y-%H-%M-%S") + ".png")
      raise e.message
    end
  end
  
  def latest_Coupon_Widget_RightRail
    begin
      if (@driver.find_element(:css, ".latest_coupons").displayed? == true)
        @doc = Nokogiri::HTML(open(@driver.current_url))       
        @doc.css(".latest_coupons li").size.should > 0
      end
    rescue Exception => e
      @driver.save_screenshot("Z:/Screenshots_test/Latest_Coupon_Widget_"+ Time.now.strftime("%d-%m-%s %Y-%H-%M-%S") + ".png")
      raise e.message
    end
  end

  def latest_Story_Widget_RightRail
    begin
      if (@driver.find_element(:css, ".recent_features").displayed? == true)
        @doc = Nokogiri::HTML(open(@driver.current_url))       
        @doc.css(".recent_features ul li").size.should > 0
        #@selenium.find_elements(:xpath, "//div[@id='right_column_deals']/div[4]/ul/li").size.should > 0
      end
    rescue Exception => e
      @driver.save_screenshot("Z:/Screenshots_test/Latest_Story_Widget_"+ Time.now.strftime("%d-%m-%s %Y-%H-%M-%S") + ".png")
      raise e.message
    end
  end
  
end

class Pagination

   def initialize(locator,value)
      @driver = RSpec.configuration.selenium
      @lib_obj=Function_Library.new
      @wait = Selenium::WebDriver::Wait.new(:timeout => 30) 
      @loc=locator
      @val=value
   end   

   def getContainer
      return @driver.find_element(@loc,@val)
   end 

   def getSize
      return getContainer.find_element(:css,"a[id$='last']").text.to_i     
   end

   def moveNext
      @selected=0    
      for i in 1..5
        begin
          @selected=getContainer.find_element(:css,".pagerLinkSel").text.to_i
          break
        rescue          
        end
      end

       @wait.until { @driver.find_element(:css,"a[id$='next']")}
       getContainer.find_element(:css,"a[id$='next']").click    
       @lib_obj.waitforpagetoload

       for i in 1..5
        begin
          @wait.until { @driver.find_element(:css,".pagerLinkSel")}
          @wait.until { @driver.find_element(:css,".pagerLinkSel").displayed? == true }
          @wait.until { @driver.find_element(:css,".pagerLinkSel").text.to_i == @selected+1}
          break
        rescue          
        end
       end
   end

   def movePrevious
      @selected=0    
      for i in 1..5
        begin
          @selected=getContainer.find_element(:css,".pagerLinkSel").text.to_i
          break
        rescue
        end
      end

      @wait.until { @driver.find_element(:css,"a[id$='prev']")}
      getContainer.find_element(:css,"a[id$='prev']").click      
      @lib_obj.waitforpagetoload       

      for i in 1..5
        begin
          @wait.until { @driver.find_element(:css,".pagerLinkSel")}
          @wait.until { @driver.find_element(:css,".pagerLinkSel").displayed? == true }
          @wait.until { @driver.find_element(:css,".pagerLinkSel").text.to_i == @selected-1}
          break
        rescue
        end
      end
   end   

   def moveFirst
       firstElement = getContainer.find_element(:css,"a[id$='first']")
       firstElementText = firstElement.text
       firstElement.click
       @lib_obj.waitforpagetoload
       for i in 1..5
        begin
          @wait.until { @driver.find_element(:css,".pagerLinkSel")}
          @wait.until { @driver.find_element(:css,".pagerLinkSel").displayed? == true }
          @wait.until { @driver.find_element(:css,".pagerLinkSel").text == firstElementText}
          break
        rescue          
        end
       end     
   end

   def moveLast
       lastElement = getContainer.find_element(:css,"a[id$='last']")
       lastElementText = firstElement.text
       lastElement.click
       @lib_obj.waitforpagetoload
       for i in 1..5
        begin
          @wait.until { @driver.find_element(:css,".pagerLinkSel")}
          @wait.until { @driver.find_element(:css,".pagerLinkSel").displayed? == true }
          @wait.until { @driver.find_element(:css,".pagerLinkSel").text == lastElementText}
          break
        rescue          
        end
       end     
   end
end