require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "rspec"
require "Example_Group"
require "spec_helper"

describe "Verify Ads tag on Homepage" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage  
  end

  describe "Verify adheader 401- 728x90" ,:selenium => true do
    it"Verify adheader 401- 728x90 " do
      @lib_obj.check_ads_display("ad728x90homedoor_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90homedoor_ATF","Verify adheader 401- 728x90"
  end
  
  describe "Verify adheader 403 - 300x250homedoor_ATF" ,:selenium => true do
    it"Verify adheader ad403 - 300x250 homedoor_ATF  " do
      @lib_obj.check_ads_display("ad300x250homedoor_ATF",300,250)
    end
  end
  
  describe "Verify adheader 403 - 300x250homedoor_ATF - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250homedoor_ATF","Verify adheader ad403 - 300x250homedoor_ATF"
  end
    
  describe "adModule ad403- ad336x250 homedoor_module" ,:selenium => true do 
    it"adModule ad403- ad336x250 homedoor_module" do
      @lib_obj.check_ads_display("ad336x250homedoor_module",336,250)  
    end
  end
  
  describe "adModule ad403- ad336x250 homedoor_module - tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250homedoor_module","adModule ad403- ad336x250 homedoor_module"
  end
  
  describe "Verify adheader 405- 1x1" ,:selenium => true do
    it"Verify adheader 405- 1x1 " do
      @lib_obj.check_ads_display("ad1x1homedoor_pixel", 1, 1)
    end
  end
  
  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1homedoor_pixel","Verify adheader 405- 1x1"
  end
  
  describe "Verify adModule ad405 - 1x2" ,:selenium => true do
    it"Verify adModule ad405 - 1x2 " do
      @lib_obj.check_ads_display("ad1x2homedoor_special",1,2)
    end
  end
  
  describe "Verify adModule ad405 - 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2homedoor_special","Verify adModule ad405 - 1x2"
  end
    
  describe "Verify adModule ad411- 1x3" ,:selenium => true do
    it"Verify adModule ad411- 1x3 " do
      @lib_obj.check_ads_display("ad1x3homedoor_exotic", 1, 3)
    end 
  end
  
  describe "Verify adModule ad411- 1x3 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x3homedoor_exotic","Verify adModule ad411- 1x3"
  end
    
  describe "adheader416 - 272x100 homedoor_module2" ,:selenium => true do 
    it "adheader416 - 272x100 homedoor_module2" do
      @lib_obj.check_ads_display("ad272x100homedoor_module2",272,100)
    end
  end
  
  describe "adheader416 - 272x100 homedoor_module2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100homedoor_module2","adheader416 - 272x100 homedoor_module2"
  end
end #describe end
