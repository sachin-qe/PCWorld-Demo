require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Archives link on Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end
  
  it "Verify Goes to the Archives page" do
    @Template.clickandwait(@selenium.find_element(:css,"li#menu-item-1550560>a"))
    @selenium.current_url.should == "#{@Template.get_Base_URL}/archives/"
  end
   
  it "Verify Open Link page with response code 200" do
    @Template.verify_response_code(200).should == true
  end

  it"Verify Page Title is correct"do
    @Template.verifyText("css","title","Archives | Geek.com")  
  end

  it "Verify Header exists" do
    @Template.getHeader.displayed?.should == true
  end

  it "Verify Footer exists" do
    @Template.getFooter.displayed?.should == true
  end
  
  it "Verify Article archives in month links exists for each year " do
    element = @selenium.find_elements(:css,"ul.archive.narrow")
    for i in 0..element.size-1
      if(element[i].find_element(:css,"h4").text == Time.now.year.to_s)
        if(Time.now.day.to_s == "1")
          element[i].find_elements(:tag_name,"li").size().should be  == Time.now.month.to_i - 1
        else
          totalmonth = Time.now.month.to_s
          size = element[i].find_elements(:tag_name,"li").size()
          size.should == totalmonth.to_i
        end 
      elsif(element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/h4").text == "1999")
        element[i].find_elements(:tag_name,"li").size.should == 4  
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[1]/a").text.should == "December"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[2]/a").text.should == "November"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[3]/a").text.should == "October"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[4]/a").text.should == "September"
      else
        element[i].find_elements(:tag_name,"li").size.should == 12 
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[1]/a").text.should == "December"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[2]/a").text.should == "November"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[3]/a").text.should == "October"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[4]/a").text.should == "September"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[5]/a").text.should == "August"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[6]/a").text.should == "July"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[7]/a").text.should == "June"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[8]/a").text.should == "May"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[9]/a").text.should == "April"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[10]/a").text.should == "March"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[11]/a").text.should == "February"
        element[i].find_element(:xpath,"//section[@id='content']/div[3]/ul[#{i+1}]/li[12]/a").text.should == "January"
      end
    end
  end
  
  it "Verify  Follow on Google plus, Deal of the Day, Geek Newsletter block and More Geek block exists" do
    @Template.leftpanel_widget_displayed
  end
end
