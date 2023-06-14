require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"

describe "Verify Terms of Use footer link", :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end

  it "Verify it should be able to click on Terms of Use Link" do
    element = @selenium.find_element(:xpath, "//div[@id='lb-footer']//a[.='Terms of Use']")
    if(element.attribute("target")=="_blank")
      @selenium.execute_script("arguments[0].setAttribute('target', '_self');",element)
    end
    @lib_obj.clickandwait(element)
    @wait.until { @selenium.find_element(:css,"h1").displayed? == true }   
  end

  it "Verify it goes to correct url" do
    @selenium.current_url.should include "http://www.ziffdavis.com/terms-of-use"   
  end

  it "Verify HTTP response is 200" do
    @lib_obj.verify_response_code(200).should == true
    @lib_obj.navigateback
  end
end