require 'rake'
require 'rspec'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Editors Choice Link on Homepage" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify it should be able to click on Editors Choice Article Link" do
    # @selenium.execute_script("document.getElementById('award-winners').scrollIntoView()")
    @lib_obj.clickandwait(@selenium.find_element(:xpath, "//div[@id='award-winners']/ul/li[1]//img"))
  end

  it "Verify it goes to correct URL" do
    @selenium.current_url.should include "#{@lib_obj.get_Base_URL}" + "/editors-choice"
  end
  
  it "Verify it opens Editor's Choice page with response code 200" do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Page Title is correct " do
    @Nokogiri.verifyText("css","title","Computer and Product Reviews - Editors' Choice | PCMag.com")
  end

  it "Verify The page is populated with search results" do
    @Nokogiri.getSize("css",".product-item").should >= 1
  end

  it "Verify Header exists" do
    @lib_obj.check_page_header.should == true
  end

  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should == true
  end
end
