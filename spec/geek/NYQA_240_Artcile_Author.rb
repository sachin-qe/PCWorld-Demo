require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Author_gtempleton Page" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @selenium.get("#{@Template.get_Base_URL}/author/gtempleton/")
  end  

  it "Verify it opens page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify it goes to correct URL" do
    @selenium.current_url.should == "#{@Template.get_Base_URL}/author/gtempleton/"
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","Graham Templeton | Author Bio | Geek.com")
  end

  it "Verify All articles are authored by 'Graham Templeton' " do
    @Template.getSize("css","div.section2").should >= 1
    @selenium.find_elements(:css,"div.section2").each do|element|
      element.find_element(:css,"span.by>a").text.should == "Graham Templeton"
    end
  end
  
  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
end
