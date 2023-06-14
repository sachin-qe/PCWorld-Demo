require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Footer and all links" ,:selenium => true,:retry => 3 do
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

  it "Verify to make sure footer exists" do
    @Template.getFooter.displayed?.should == true 
  end
  
  it "Verify to make sure All links are clickable under ABOUT" do
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    for i in 1..@doc.xpath("//div[@id='lb-footer']/div[1]/ul/li").size
    #for i in 1..@selenium.find_elements(:xpath, "//div[@id='lb-footer']/div[1]/ul/li").size
      #href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[1]/ul/li[#{i}]/a","href")
      href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[1]/ul/li[#{i}]/a").attribute("href")
      #href_val = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[1]/ul/li[#{i}]/a").attribute("href")
      @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[1]/ul/li[#{i}]/a").click
      @selenium.current_url.should == "#{href_val}"
      #Get back to base url 
      @selenium.navigate.back
      @lib_obj.waitforpagetoload
    end
  end
  
   it "Verify to make sure All links are clickable under CONNECT" do  
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    for i in 1..@doc.xpath("//div[@id='lb-footer']/div[2]/ul/li").size  
      href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a","href")
      #href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a").attribute("href")
      #href_val = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a").attribute("href")
      link_text = @Nokogiri.getText("xpath", "//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a")    
      #link_text = @doc.xpath("//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a").text
      #link_text = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a").text
      @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[2]/ul/li[#{i}]/a").click
      if(link_text == "Deal Alerts")      
        @wait.until { @selenium.find_element(:id, "info_div").displayed? == true }
        @selenium.current_url.should be == "#{@base_url}" + "/login.aspx?ReturnUrl=%2fdealalerts.aspx"
        #@wait.until { @selenium.find_element(:link_text, "Submit A Deal").displayed? == true }
      elsif(link_text == "Submit A Deal")
        @selenium.current_url.should include "http://www.logicbuy.com/login.aspx?"
        @selenium.navigate.back
        @lib_obj.waitforpagetoload
      else
        @selenium.current_url.should == "#{href_val}"
        #Get back to base url 
        @selenium.navigate.back
        @lib_obj.waitforpagetoload
      end    
    end
  end
  
  it "Verify to make sure All links are clickable under LEGAL" do  
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    for i in 1..@doc.xpath("//div[@id='lb-footer']/div[3]/ul/li").size
    #for i in 1..@selenium.find_elements(:xpath, "//div[@id='lb-footer']/div[3]/ul/li").size
      #href_val = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").attribute("href")
      link_text = @Nokogiri.getText("xpath", "//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a")    
      #link_text = @doc.xpath("//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").text
      #link_text = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").text
      if(link_text == "Privacy Policy" || link_text == "Terms of Use")
        href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a","href")
        #href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").attribute("href")
        @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").click
        @selenium.switch_to.window(@selenium.window_handles.last)
        @selenium.title.include?("Ziff Davis").should be == true
        @selenium.title.include?("#{link_text}").should be == true
        @selenium.close
        @selenium.switch_to.window(@selenium.window_handles.first)
      elsif(link_text == "AdChoices")
        sleep 3 #required for ie
        @selenium.switch_to.frame "_ev_iframe"
        @wait.until { @selenium.find_element(:id, "apply-changes") }
        @selenium.execute_script("document.getElementById('apply-changes').scrollIntoView()")
        @selenium.find_element(:id, "apply-changes").click
        @selenium.switch_to.default_content 
      elsif(link_text == "Advertise")
        href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a","href")
        #href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").attribute("href")
        @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[3]/ul/li[#{i}]/a").click
        @selenium.current_url.should == "#{href_val}"
        #Get back to base url 
        @lib_obj.open_base_URL(@base_url)
        @lib_obj.waitforpagetoload
      else
        @lib_obj.open_base_URL(@base_url)
        @lib_obj.waitforpagetoload
      end
    end
  end
  
  it "Verify to make sure All links are clickable under OUR SITES" do  
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    for i in 1..@doc.xpath("//div[@id='lb-footer']/div[4]/ul/li").size
    #for i in 1..@selenium.find_elements(:xpath, "//div[@id='lb-footer']/div[4]/ul/li").size
      #@wait.until { @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[4]/ul/li[#{i}]/a").displayed? == true }
      href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[4]/ul/li[#{i}]/a","href")
      #href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[4]/ul/li[#{i}]/a").attribute("href")
      #href_val = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[4]/ul/li[#{i}]/a").attribute("href")
      @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[4]/ul/li[#{i}]/a").click
      @selenium.switch_to.window(@selenium.window_handles.last)
      @selenium.current_url.should include href_val.to_s.split("://www.").last
      @selenium.close
      @selenium.switch_to.window(@selenium.window_handles.first)
    end
  end
  
  it "Verify to make sure All links are clickable under SOCIAL" do  
    @doc = Nokogiri::HTML(open(@selenium.current_url))
    # @wait.until { @selenium.find_element(:css, "#footer").displayed? == true }
    for i in 1..@doc.xpath("//div[@id='lb-footer']/div[5]/ul/li").size
    #for i in 1..@selenium.find_elements(:xpath, "//div[@id='lb-footer']/div[5]/ul/li").size
      # @wait.until { @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").displayed? == true }
      href_val = "#{@base_url}" + @Nokogiri.getAttribute("xpath","//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a","href")
      #href_val = "#{@base_url}" + @doc.xpath("//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").attribute("href")
      #href_val = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").attribute("href")
      link_text = @Nokogiri.getText("xpath", "//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a")
      #link_text = @doc.xpath("//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").text
      #link_text = @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").text
      @selenium.find_element(:xpath, "//div[@id='lb-footer']/div[5]/ul/li[#{i}]/a").click    
      @selenium.switch_to.window(@selenium.window_handles.last)
      if (link_text == "Google+")
        @selenium.current_url.should include "plus.google.com"
      else
        @selenium.current_url.should include href_val.to_s.split("http://").last
      end
      @selenium.close
      @selenium.switch_to.window(@selenium.window_handles.first)
    end
  end
end # Describe end
