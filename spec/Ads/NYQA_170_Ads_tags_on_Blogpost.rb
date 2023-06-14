require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "rspec"
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on Blog post page" ,:selenium => true,:retry => 3 do
  before(:all) do    
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @config = @lib_obj.path_setup
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("http://#{@config['baseurl3']}/hacking/316157-apple-s-iphone-5s-touch-id-may-be-hacked-but-it-s-still-awesome")
  end

  describe "Verify adheader 401- 728x90 - Displayed" ,:selenium => true do
    it"Verify adheader 401- 728x90 " do
      @lib_obj.check_ads_display("ad728x90securitywatchsection_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90securitywatchsection_ATF","Verify adheader 401- 728x90"
  end

  describe "Verify adheader 403- 300x250 - Displayed" ,:selenium => true do
    it"Verify adheader 403- 300x250 securitywatchsection_ATF  " do
      @lib_obj.check_ads_display("ad300x250securitywatchsection_ATF", 300, 250)
    end 
  end

  describe "Verify adheader 403- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250securitywatchsection_ATF","Verify adheader 403- 300x250"
  end

  describe "Verify adModule 403- 336x250 - Displayed" ,:selenium => true do
    it"Verify adModule ad403- ad336x250 securitywatchsection_module" do
      @lib_obj.check_ads_display("ad336x250securitywatchsection_module", 336, 250)
    end 
  end
  
  describe "Verify admodule 403- 336x250- tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250securitywatchsection_module","Verify adModule 403- 336x250"
  end

  describe "Verify adheader 405- 1x1 - Displayed" ,:selenium => true do
    it"Verify adheader 405- 1x1 " do
      @lib_obj.check_ads_display("ad1x1securitywatchsection_pixel", 1 ,1)
    end
  end 

  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1securitywatchsection_pixel","Verify adheader 405- 1x1"
  end

  describe "Verify adheader 405- 1x2 - Displayed" ,:selenium => true do
    it"Verify adModule ad405 - 1x2 " do
      @lib_obj.check_ads_display("ad1x2securitywatchsection_special", 1, 2)
    end 
  end

  describe "Verify adheader 405- 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2securitywatchsection_special","Verify adheader 405- 1x2"
  end

  describe "Verify adheader 416- 272x100 - Displayed" ,:selenium => true do
    it "Verify adheader416 - 272x100 securitywatchsection_module2" do
      @lib_obj.check_ads_display("ad272x100securitywatchsection_module2", 272, 100)
    end
  end

  describe "Verify adheader 416- 272x100 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100securitywatchsection_module2","Verify adheader 416- 272x100"
  end
end #describe end
