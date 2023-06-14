require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category_Article Reviews_Link2" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)   
    @wait = @Template.set_timeout(30)
    @selenium.get("#{@Template.get_Base_URL}/review/add-touch-to-any-pc-with-the-lenovo-thinkvision-lt1423p-1551899/")
  end  

  it "Verify Open page with response code 200 " do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Goes to correct URL" do
    @selenium.current_url.should == "#{@Template.get_Base_URL}/review/add-touch-to-any-pc-with-the-lenovo-thinkvision-lt1423p-1551899/"
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","Add touch to any PC with the Lenovo ThinkVision LT1423p touchscreen | Reviews | Geek.com") 
  end

  it "Verify Header Exists" do
    @Template.getHeader.displayed?.should == true
  end
 
  it "Verify Footer Exists" do
    @Template.getFooter.displayed?.should == true
  end
  
  it "Verify Top Next and Top Previous article links exists" do
    @Template.next_previous_at_top
  end

  it "Verify Bottom Next and Bottom Previous article links exists " do
    @Template.next_previous_at_bottom
  end
  
  it "Verify Article body exists" do
    @selenium.find_element(:css,"div.articleinfo>article").displayed? == true
  end

  it "Verify Click on TOP link and check it actually goes to the top " do
    @Template.top_link_check
  end

  it "Verify Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end

  it "Verify Outbrain module exists" do
    @Template.check_outbrain_module
  end

  it "Verify Disqus module exists" do
    # Check disqus comment section exists
    @Template.check_disqus_comment_section
  end
end
