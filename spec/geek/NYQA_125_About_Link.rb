require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify About link on Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end

  it "Verify Goes to the About page" do
    @selenium.execute_script("document.getElementById('menu-item-1550231').scrollIntoView();")
    @Template.clickandwait(@selenium.find_element(:css,"#menu-item-1550230 a"))
    @selenium.current_url.should == "#{@Template.get_Base_URL}/about/"
  end
   
  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","About | Geek.com")  
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
  
  it "Verify Page is populated with About page content " do
    @selenium.find_element(:css,"div.articleinfo>article").displayed? == true
    @selenium.find_elements(:css,"div.articleinfo>article>*").size.should >= 1
  end
  
  it "Verify Follow on Google plus, Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end
end
