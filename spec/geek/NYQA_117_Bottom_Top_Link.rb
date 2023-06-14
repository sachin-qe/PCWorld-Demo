require 'selenium-webdriver'
require 'rspec'
require 'rake'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify Category_Article_Bottom Top Link on Article Page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @Template = TemplatePage.new(@selenium)
    @wait = @Template.set_timeout(30)
    @Template.open_homepage
  end  
  
  it "Verify the Top Link at bottom can be navigated to from the Article page. " do
    @Template.clickandwait(@selenium.find_element(:css, "article.right h3>a"))      	
  end

  it "Verify Click on TOP link and check it actually goes to the top" do
    @Template.top_link_check
  end

end # Describe end