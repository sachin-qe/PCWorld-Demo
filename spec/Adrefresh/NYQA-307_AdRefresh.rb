require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

refs = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/Ads_Links.yml'))

describe "Verify Ad Refresh", :critical => true do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @config = @lib_obj.path_setup
    @base_url = "http://#{@config.options['baseurl']}"
  end

  for i in 1..5
    it "Verify that the page gets loaded and check for top ad refresh" do
      # Mouse hover over All Reviews link
      i = rand(26)
      @lib_obj.open_base_URL("#{@base_url}#{refs[i]}")
      @wait.until { @selenium.find_element(:css,"#footer").displayed? == true }
      @selenium.find_element(:class, "site-logo").click
      @wait.until { @selenium.find_element(:css,"#footer").displayed? == true }
      @top_ad_before_refresh = @Nokogiri.getAttribute("css","#ad401-1 iframe","src")
      @bottom_ad_before_refresh = @Nokogiri.getAttribute("css","#ad414-1 iframe","src")
      @ad_before_refresh_ATF = @Nokogiri.getAttribute("css",".adModule.ad403 iframe","src")
      @ad_before_refresh_BTF = @Nokogiri.getAttribute("css","#ad415-1 iframe","src")
      sleep 200
    end
    
    it "Verify that the top ad gets refreshed" do
      top_ad_after_refresh = @Nokogiri.getAttribute("css","#ad401-1 iframe","src")
      top_ad_after_refresh.should_not == @top_ad_before_refresh
    end
    
    it "Verify that the bottom ad gets refreshed" do
      bottom_ad_after_refresh = @Nokogiri.getAttribute("css","#ad414-1 iframe","src")
      bottom_ad_after_refresh.should_not == @bottom_ad_before_refresh
    end
    
    it "Verify that the ad in story section gets refreshed" do
      ad_after_refresh_ATF = @Nokogiri.getAttribute("css",".adModule.ad403 iframe","src")
      ad_after_refresh_ATF.should_not == @ad_before_refresh_ATF 
    end
    
    it "Verify that the ad gets in right rails refreshed" do
      ad_after_refresh_BTF = @Nokogiri.getAttribute("css","#ad415-1 iframe","src")
      ad_after_refresh_BTF.should_not == @ad_before_refresh_BTF
    end  
  end
end # Describe ends










