require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Page_Welcome to the new Geek" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("http://qa.geek.com/news/welcome-to-the-new-geek-com-1544556/")
  end  

  after(:all)do
    @selenium.get(@lib_obj.get_Base_URL)
  end
   
  it "Verify Open page with response code 200 " do
    @lib_obj.verify_response_code(200).should == true
  end

  it "Verify that Photo Gallery_Can Scroll Through Photos" do
    begin
      @lib_obj.clickandwait(@selenium.find_element(:css,"div[id^='CM8SkipContainer']"))
    rescue Exception => e 
    end
    @lib_obj.clickandwait(@selenium.find_element(:css,".attachment-post-thumbnail.wp-post-image"))
    @selenium.find_element(:css,"div.tn3a-image").displayed?.should == true
    element = @selenium.find_element(:css,".tn3a-thumbs ul")
    for i in 2..element.find_elements(:tag_name,"li").size
      text_before = @selenium.find_element(:css,"div.tn3a-image-description").text
      @lib_obj.clickandwait(@selenium.find_element(:xpath,"//div[@class='tn3a-thumbs']//ul/li[#{i}]/div"))
      text_after = @selenium.find_element(:css,"div.tn3a-image-description").text
      text_after.should_not == text_before
    end
  end
end
