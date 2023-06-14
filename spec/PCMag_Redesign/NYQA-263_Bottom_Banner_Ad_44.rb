require 'rake'
require 'selenium-webdriver'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"

describe "Verify bottom banner ad on Homepage" , :selenium => true,:retry => 3 do
  browser = ENV['browser']
  platform = ENV['platform']

  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify bottom banner ad on Homepage exists" do
    @selenium.switch_to.frame(@selenium.find_element(:id,"ad728x90homedoor_BTF"))

    begin
      @wait.until{@selenium.find_element(:css, "#ad-container>a>img")}
      @selenium.find_element(:css, "#ad-container>a>img").displayed?.should be == true
      @Nokogiri.getAttribute("css", "#ad-container>a>img","width").should be == "728"
      @Nokogiri.getAttribute("css", "#ad-container>a>img","height").should be == "90"  
    rescue Exception => e
      @selenium.switch_to.default_content  
      fail(e.message)
    end   
  end
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true   
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true
  end
end # Describe ends
