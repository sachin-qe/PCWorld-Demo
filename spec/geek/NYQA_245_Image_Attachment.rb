require "rake"
require "selenium-webdriver"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Image Attachments on url" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("http://qa.geek.com/wp-content/uploads/2013/06/mecam_2-620x420.png")
  end  
  
  it "Verify image attachments" do
    @selenium.find_element(:css,"img").displayed?.should == true
  end
  
  after(:all) do
    @selenium.get(@lib_obj.get_Base_URL)
  end
end
