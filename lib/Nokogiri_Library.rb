require "selenium-webdriver"
require "rest-client"
require "rubygems"
require "nokogiri"
require "open-uri"

class Nokogiri_Library

   def set_driver(driver)
    @driver = driver
   end 
   
   def getPageSource
     return Nokogiri::HTML(@driver.page_source)
   end

   def getSize(locator,value)
   	html_doc = Nokogiri::HTML(@driver.page_source)
   	if(locator=="xpath")
   		return html_doc.xpath("#{value}").size
   	else
   		return html_doc.css("#{value}").size
   	end	
   end

   def verifyText(locator,value,text)
      html_doc = Nokogiri::HTML(@driver.page_source)
      if(locator=="xpath")
         html_doc.at("#{value}").text.include?("#{text}").should == true
      else
         html_doc.at_css("#{value}").text.include?("#{text}").should == true
      end   
   end

   def getAttribute(locator,value,attribute)
      html_doc = Nokogiri::HTML(@driver.page_source)
      if(locator=="xpath")
         return html_doc.at("#{value}")["#{attribute}"]
      else
         return html_doc.at_css("#{value}")["#{attribute}"]
      end   
   end

   def getText(locator,value)
      html_doc = Nokogiri::HTML(@driver.page_source)
      if(locator=="xpath")
         return html_doc.at("#{value}").text
      else
         return html_doc.at_css("#{value}").text
      end   
   end
   
   def metarefresh_nokogiri(verification_url)
     doc = Nokogiri::HTML(open(verification_url))
     test = doc.to_s
     if(test.include?('__PCMAG.adRefreshRate') == true)
        string = test.split('__PCMAG.adRefreshRate').last.split(';').first.split(' = ').last
        string.should_not == "undefined"
        string.should =~ /[0-9]+/
      end
   end
   
   def canonicals_nokogiri(verification_url, href_val)
      doc = Nokogiri::HTML(open(verification_url))
      doc.at_css("link[rel='canonical']").attribute("rel").to_s.should == "canonical"
      doc.css('link[rel=canonical]').attribute("href").to_s.include?(href_val).should == true
   end
end