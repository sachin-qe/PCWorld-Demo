require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category_Article_More Geek Left Rail Module" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "Verify More geek widget exists and displayed in left rail on article page" do
    # Click on top article
    @lib_obj.clickandwait(@selenium.find_element(:css, ".topcontent h2>a"))
    @selenium.find_element(:id, "more_posts_by_category-2").displayed?.should == true
    @selenium.find_element(:class, "moreongeek").displayed?.should == true
    @lib_obj.getSize("css",".moreongeek>*").should >= 1
  end
end