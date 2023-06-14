require "rake"
require "selenium-webdriver"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category_Article_Disqus" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end  
  
  it "Verify Disqus widget exists and displayed on article page" do
    # Click on top article
    @lib_obj.clickandwait(@selenium.find_element(:css, "article.right h3>a"))
    @selenium.find_element(:css, "div#disqus_thread").displayed?.should == true
  end
end