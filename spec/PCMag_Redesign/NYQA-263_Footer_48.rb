require 'rake'
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"
require "rest-client"

describe "Verify Footer and all links" ,:selenium => true do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.open_homepage
  end

  after(:all) do
    @lib_obj.open_base_URL(@base_url)
  end
  
  it "Verify All links are clickable under ABOUT" do
    fail_array = Array.new
    for i in 1..@Nokogiri.getSize("xpath","//div[@class='footer-col']/ul[1]/li")
      link = @selenium.find_element(:xpath,"//div[@class='footer-col']/ul[1]/li[#{i}]/a")
      link_text = link.text
      href = link.attribute("href")
      if(link.attribute("target")=="_blank")
        @selenium.execute_script("arguments[0].setAttribute('target', '_self');",link)
      end
      @lib_obj.clickandwait(link)
      begin
        if(link_text == "AdChoices") 
          sleep 3
          @selenium.switch_to.frame "_ev_iframe"
          @selenium.execute_script("document.getElementById('apply-changes').scrollIntoView();")
          @wait.until{@selenium.find_element(:id, "apply-changes").displayed? == true}
          @lib_obj.clickandwait(@selenium.find_element(:id, "apply-changes"))
          @selenium.switch_to.default_content 
        else
          if(link_text == "Privacy Policy" || link_text == "Terms of Use")       
            @selenium.title.include?("Ziff Davis").should be == true
            @selenium.title.include?("#{link_text}").should be == true
          else
            @selenium.current_url.should include "#{href}".to_s.split("://www.").last
          end
          @lib_obj.navigateback 
        end
      rescue Exception => e
        fail_array.push("#{link_text}")
      end  
    end
    if(fail_array.size > 0)
      fail "failed links #{fail_array}"
    end   
  end

  it "Verify All links are clickable under CONNECT" do
    fail_array = Array.new
    for i in 1..@Nokogiri.getSize("xpath","//div[@class='footer-col']/ul[2]/li")
      link = @selenium.find_element(:xpath,"//div[@class='footer-col']/ul[2]/li[#{i}]/a")
      link_text = link.text
      href = link.attribute("href")
      @lib_obj.clickandwait(link)
      begin
        @selenium.current_url.should include "#{href}".to_s.split("://www.").last
      rescue Exception => e
        fail_array.push("#{link_text}")
      end 
      @lib_obj.navigateback
    end
    if(fail_array.size > 0)
      fail "failed links #{fail_array}"
    end  
  end

  it "Verify All links are clickable under ZIFF DAVIS SITES" do
    fail_array = Array.new
    for i in 1..@Nokogiri.getSize("xpath","//div[@class='footer-col']/ul[3]/li")
      link = @selenium.find_element(:xpath,"//div[@class='footer-col']/ul[3]/li[#{i}]/a")
      link_text = link.text
      href = link.attribute("href")
      if(link.attribute("target")=="_blank")
        @selenium.execute_script("arguments[0].setAttribute('target', '_self');",link)
      end
      @lib_obj.clickandwait(link)
      begin
        @selenium.current_url.should include "#{href}".to_s.split("://www.").last
      rescue Exception => e
        fail_array.push("#{link_text}")
      end
      @lib_obj.navigateback
    end
    if(fail_array.size > 0)
      fail "failed links #{fail_array}"
    end  
  end
  
  it "Verify All links are clickable under SUBSCRIBE" do
    fail_array = Array.new
    for i in 1..@Nokogiri.getSize("xpath","//div[@class='footer-col']/ul[4]/li")
      link = @selenium.find_element(:xpath,"//div[@class='footer-col']/ul[4]/li[#{i}]/a")
      link_text = link.text
      href = link.attribute("href")
      @lib_obj.clickandwait(link)
      begin
        if(link_text == "Sony Reader")
          @Nokogiri.verifyText("css","body","Sony")      
        else 
          @selenium.title.include?("PC Magazine").should  == true
        end
      rescue Exception => e
        fail_array.push("#{link_text}")
      end
      if(link_text == "Apple iOS")
        @lib_obj.open_base_URL(@base_url)
      else
        @lib_obj.navigateback
      end
    end
    if(fail_array.size > 0)
      fail "failed links #{fail_array}"
    end  
  end

  it "Verify All links are clickable under SOCIAL" do
    fail_array = Array.new
    for i in 1..@Nokogiri.getSize("xpath","//div[@class='footer-col']/ul[5]/li")
      link = @selenium.find_element(:xpath,"//div[@class='footer-col']/ul[5]/li[#{i}]/a")
      link_text = link.text
      href = link.attribute("href")
      if(link.attribute("target")=="_blank")
        @selenium.execute_script("arguments[0].setAttribute('target', '_self');",link)
      end
      @lib_obj.clickandwait(link)
      begin
        @selenium.current_url.should include "#{href}".to_s.split("://www.").last
      rescue Exception => e
        fail_array.push("#{link_text}")
      end
      @lib_obj.navigateback
    end
    if(fail_array.size > 0)
      fail "failed links #{fail_array}"
    end  
  end
end
