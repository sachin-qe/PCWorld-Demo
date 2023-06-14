require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "Nokogiri_Library"

describe "Verify All CATEGORIES Link on Homepage", :selenium => true,:retry => 3 do
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

  it "Verify it should be able to click on All Reviews-All CATEGORIES link" do
    @lib_obj.mousehover("link","ALL REVIEWS")
    @lib_obj.clickandwait(@selenium.find_element(:link, "ALL CATEGORIES"))
    @wait.until{ @selenium.find_element(:css, "h1").displayed? == true }
  end

  it "Verify it should have the correct header" do
    @Nokogiri.verifyText("css","#pg-table>h1","Product Guides")
  end

  it "Verify it opens Product guide page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify it goes to correct URL" do
    href = @Nokogiri.getAttribute("xpath","//a[.='all categories']","href")
    @selenium.current_url.should include "#{href}"
  end

  it "Verify Page Title is correct" do
    @Nokogiri.verifyText("css","title","Product Guides")
  end

  it "Verify all links are clickable on product guide page" do
    @link_container = @selenium.find_element(:css, "#pg-table")
    @links = @link_container.find_elements(:css, "a")
      for j in 0..@links.size-1 
          @links[j].enabled?.should be == true
          @links[j].displayed?.should be == true  
      end
  end

  it "Verify Header exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end 
