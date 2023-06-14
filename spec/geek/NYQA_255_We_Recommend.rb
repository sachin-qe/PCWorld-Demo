require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category-Article_We Recommend" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "We Recommend widget exists and displayed on article page" do
    # Click on top article
    @lib_obj.clickandwait(@selenium.find_element(:css, "article.right h3>a"))
    @selenium.find_element(:class, "ob_dual_left").displayed?.should == true
  end
end