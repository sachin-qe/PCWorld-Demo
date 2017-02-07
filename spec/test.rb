require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "rspec"

describe "Verify Homepage" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @template_obj = TemplatePage.new(@selenium)
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(60)
    @lib_obj.open_homepage
  end
  
  context 'UI verification' do

    it "Verify page load correctly" do
      expect(@lib_obj.verify_response_code(200)).to be true
    end

    it "Verify page title" do
      expect(@selenium.title).to eql('PCWorld - News, tips and reviews from the experts on PCs, Windows, and more')
    end

    it "Verify logo image" do
      # expect(@selenium.find_element(:id, "logoImage").displayed?).to be_truthy
      expect(@template_obj.elementisDisplayed('id', 'logoImage')).to be true
    end

    it "Verify correct page footer" do    
      expect(@selenium.find_element(:id, "footer").displayed?).to be_truthy
      # expect(@template_obj.elementisDisplayed('id','footer')).to be true
    end
  end

end