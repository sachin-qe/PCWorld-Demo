require 'rake'
require 'selenium-webdriver'
require 'rspec'
require 'Function_Library'
require "spec_helper"
require "open-uri"
require "Nokogiri_Library"

describe "Verify the Cover story on Homepage" , :selenium => true,:retry => 3 do
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
  
  it "Verify Cover story exists on homepage" do
    #To Check that cover story exists
    @wait.until{@selenium.find_element(:css, ".top-story")}
    @selenium.find_element(:css,".top-story").displayed?.should be == true
    #TO check that story has title
    @selenium.find_element(:css,".top-story h1>a").displayed?.should be == true
    #TO check that story has image
    @selenium.find_element(:css,".top-story img").displayed?.should be == true
    #TO check that story has content
    @selenium.find_element(:css,".top-story p").displayed?.should be == true
  end

  it"Verify it goes to correct url" do
    href_val=@Nokogiri.getAttribute("css",".top-story h1>a","href")
    @lib_obj.clickandwait(@selenium.find_element(:css,".top-story h1>a"))
    @selenium.current_url.should include "#{href_val}"
  end

  it"Verify it should have header" do
    @selenium.find_element(:css,"h1").displayed?.should be == true
  end 

  it"Verify it should have disqus module" do
    @lib_obj.check_disqus_comment_section
  end

  it"Verify it should have outbrain module" do
    @lib_obj.check_outbrain_module
  end

  it "Verify facebooktrend section should not be empty" do 
    @selenium.find_element(:css,"#facebooktrend").displayed?.should be == true
  end 
  
  it "Verify Header exists" do
    @lib_obj.check_page_header.should be == true   
  end
  
  it "Verify Footer exists" do
    @lib_obj.check_page_footer.should be == true
  end
end
