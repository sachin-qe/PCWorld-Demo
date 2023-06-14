require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "nokogiri"
require "open-uri"

Dir[File.dirname(__FILE__) + '/../../pages/logicbuy/*.rb'].each {|file| require file }

describe "Verify Site Map page", :selenium => true,:retry => 3 do
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

  it "Verify to click on Sitemap from Footer link" do
    @lib_obj.waitforpagetoload
    @selenium.find_element(:link, "Site Map").click
    @lib_obj.waitforpagetoload
  end
  
  describe "Verify sitemap page" do
    before(:all) do
      @doc = Nokogiri::HTML(open(@selenium.current_url))
    end
    
    it "Verify page response code is 200" do
      @lib_obj.page_response_code.should == true
    end

    it "Verify Page title is correct" do
      @Nokogiri.verifyText("css", "title", "Site Map | LogicBuy")
      #@doc.at_css("title").text.should include "Site Map | LogicBuy"
    end

    it "Verify the page heading SITE MAP exists" do
      @Nokogiri.verifyText("xpath", "//*[@id='about_header']", "Site Map")
      #@doc.at("//*[@id='about_header']").text.should == "Site Map"  
    end
    
    it "Verify Page content exists" do
      @selenium.find_element(:xpath,"//*[@id='sitemap']").displayed?.should == true   
    end

    it "Verify category links are present in the CATEGORIES block" do
      @doc.at("//*[@id='sitemap']").css(".sitemap_subheader").size.should >= 1
    end
    
    it "Verify in Categories block, to click on present links and check that it redirects to the clicked category pages" do
      for i in 1..@doc.css(".sitemap_subheader").size
        link_href = @Nokogiri.getAttribute("xpath", "//div[@class='sitemap_subheader'][#{i}]/h3/a", "href")
        #link_href = @doc.at("//div[@class='sitemap_subheader'][#{i}]/h3/a").attribute('href').to_s
        @selenium.find_element(:xpath,"//div[@class='sitemap_subheader'][#{i}]/h3/a").click
        @lib_obj.waitforpagetoload
        #@wait.until{@selenium.find_element(:xpath,"//div[@class='deal_breadcrumbs']").displayed? == true}
        @selenium.current_url.should include("#{link_href}")
        @selenium.navigate.back
        @wait.until{@selenium.find_element(:css,"h1").displayed? == true}
        if(@doc.at("//div[@class='sitemap_subheader'][#{i}]/ul[@class='sitemap']").css("li").size >= 1)
          for j in 1..@doc.at("//div[@class='sitemap_subheader'][#{i}]/ul[@class='sitemap']").css("li").size
            sublink_href = @Nokogiri.getAttribute("xpath", "//div[@class='sitemap_subheader'][#{i}]/ul[@class='sitemap']/li[#{j}]/a", "href")
            #sublink_href = @doc.at("//div[@class='sitemap_subheader'][#{i}]/ul[@class='sitemap']/li[#{j}]/a").attribute('href').to_s
            @selenium.find_element(:xpath,"//div[@class='sitemap_subheader'][#{i}]/ul[@class='sitemap']/li[#{j}]/a").click
            @wait.until{@selenium.find_element(:xpath,"//div[@class='deal_breadcrumbs']").displayed? == true}
            @selenium.current_url.should include ("#{sublink_href}")
            @selenium.navigate.back
            @wait.until{@selenium.find_element(:css,"h1").displayed? == true} 
          end   
        else
          next
        end
      end 
    end

    it "Verify links are present in the SPECIAL FEATURES block" do
      for i in 1..@doc.css("table.sitemap_specialfeatures>tr>td").size
        @doc.css("table.sitemap_specialfeatures>tr>td:nth-child(#{i})>a").size.should >= 1
      end
    end

    it "Verify to click on present links and check that it redirects to the clicked pages" do
      @selenium.find_element(:xpath, "//div[@id='footer']/div[2]/div[@class='lb-columns']/ul/li[4]/a").click
      @lib_obj.waitforpagetoload
      #@wait.until{@selenium.find_element(:css,"#footer").displayed? == true}
      for i in 1..@doc.css("table.sitemap_specialfeatures>tr>td").size
        for j in 1..@doc.css("table.sitemap_specialfeatures>tr>td:nth-child(#{i})>a").size 
          @selenium.find_element(:xpath,"//table[@class='sitemap_specialfeatures']/tbody/tr/td[#{i}]/a[#{j}]").displayed?.should be == true
          link_text = @Nokogiri.getText("xpath", "//table[@class='sitemap_specialfeatures']/tbody/tr/td[#{i}]/a[#{j}]")
          #link_text = @doc.at("//table[@class='sitemap_specialfeatures']/tr/td[#{i}]/a[#{j}]").text
          link_href = @Nokogiri.getAttribute("xpath", "//table[@class='sitemap_specialfeatures']/tbody/tr/td[#{i}]/a[#{j}]", "href")
          #link_href = @doc.at("//table[@class='sitemap_specialfeatures']/tr/td[#{i}]/a[#{j}]").attribute('href').to_s
          if(@Nokogiri.getAttribute("xpath", "//table[@class='sitemap_specialfeatures']/tbody/tr/td[#{i}]/a[#{j}]", "target").to_s == "_blank")
          #if(@doc.at("//table[@class='sitemap_specialfeatures']/tr/td[#{i}]/a[#{j}]").attribute("target").to_s == "_blank")
            @selenium.execute_script("window.open('#{link_href}','_self')")
            @selenium.execute_script("window.stop();")
          else
            @selenium.find_element(:xpath,"//table[@class='sitemap_specialfeatures']/tbody/tr/td[#{i}]/a[#{j}]").click
          end
          if("#{link_text }" == "Facebook" || "#{link_text }" == "Twitter" || "#{link_text }" == "Pinterest")
            string = link_href.split("//").last
            @selenium.current_url.should include("#{string}") 
          elsif ("#{link_text }" == "Google+")
            string = link_href.split("//").last.split("/").first
            @selenium.current_url.should include("#{string}")   
          else
            @selenium.current_url.should include("#{link_href}")
          end
          @selenium.navigate.back
          @lib_obj.waitforpagetoload
          #@wait.until{@selenium.find_element(:css,"h1").displayed? == true}
        end 
      end     
    end

    it "Verify Hottest Daily Deals Widget exists on Right Rail" do
      @Template.top_10_Deals_Widget_RightRail
    end

    it "Verify Latest Stories Widget exists on Right Rail" do
      @Template.latest_Story_Widget_RightRail
    end

    it "Verify Header exists" do
      @Template.getHeader.displayed?.should == true 
    end

    it "Verify Footer exists" do
      @Template.getFooter.displayed?.should == true 
    end
  end
end



  

