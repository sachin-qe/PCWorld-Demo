require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on Scanners page" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("#{@lib_obj.get_Base_URL}/reviews/scanners")
  end  

  describe "Verify adheader 401- size should be 728x90" ,:selenium => true do
    it "Verify adheader 401- size should be 728x90" do
      @lib_obj.check_ads_display("ad728x90scannersdoor_ATF",728,90)
    end
  end

  describe "Verify adheader 401- size should be 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90scannersdoor_ATF","Verify adheader 401- size should be 728x90"
  end
  
    describe "Verify adheader 403 - 300x250scannersdoor_ATF" ,:selenium => true do    
    it "Verify adheader 403 - 300x250scannersdoor_ATF" do
      @lib_obj.check_ads_display("ad300x250scannersdoor_ATF",300,250)  
    end
  end

  describe "Verify adheader 403 - 300x250scannersdoor_ATF - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250scannersdoor_ATF","Verify adheader 403 - 300x250scannersdoor_ATF"
  end

  describe "Verify adModule ad403 - ad336x250scannerssection_module" ,:selenium => true do
    it "Verify adModule ad403 - ad336x250scannerssection_module" do
      @lib_obj.check_ads_display("ad336x250scannersdoor_module",336,250)
    end
  end

  describe "Verify adModule ad403 - ad336x250scannerssection_module - tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250scannersdoor_module","Verify adModule ad403 - ad336x250scannerssection_module"
  end

  describe "Verify adheader 405 - 1x1" ,:selenium => true do    
    it "Verify adheader 405 - 1x1" do
      @lib_obj.check_ads_display("ad1x1scannersdoor_pixel",1,1)
    end
  end

  describe "Verify adheader 405 - 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1scannersdoor_pixel","Verify adheader 405 - 1x1"
  end

  describe "Verify adModule ad405 - 1x2" ,:selenium => true do    
    it "Verify adModule ad405 - 1x2" do
      @lib_obj.check_ads_display("ad1x2scannersdoor_special",1,2)
    end
  end

  describe "Verify adModule ad405 - 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2scannersdoor_special","Verify adModule ad405 - 1x2"
  end

  describe "Verify adModule ad411- 1x3" ,:selenium => true do
    it "Verify adModule ad411- 1x3" do
      @lib_obj.check_ads_display("ad1x3scannersdoor_exotic",1,3)
    end
  end

  describe "Verify adModule ad411- 1x3 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x3scannersdoor_exotic","Verify adModule ad411- 1x3"
  end

  describe "Verify adModule ad414 - 728x90scannersreviews_BTF" ,:selenium => true do
    it "Verify adModule ad414 - 728x90scannersreviews_BTF" do
      @lib_obj.check_ads_display("ad1x3scannersdoor_exotic",728,90)
    end
  end

  describe "Verify adModule ad414 - 728x90scannersreviews_BTF - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90scannersdoor_BTF","Verify adModule ad414 - 728x90scannersreviews_BTF"
  end

  describe "Verify adModule ad415 - 300x250scannersdoor_BTF" ,:selenium => true do
    it "Verify adModule ad415 - 300x250scannersdoor_BTF" do
      @lib_obj.check_ads_display("ad300x250scannersdoor_BTF",300,250)  
    end
  end

  describe "Verify adModule ad415 - 300x250scannersdoor_BTF - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250scannersdoor_BTF","Verify adModule ad415 - 300x250scannersdoor_BTF"
  end

  describe "Verify adheader416 - 272x100scannersdoor_module2" ,:selenium => true do
    it "Verify adheader416 - 272x100scannersdoor_module2" do
      @lib_obj.check_ads_display("ad272x100scannersdoor_module2",272,100) 
    end
  end

  describe "Verify adheader416 - 272x100scannersdoor_module2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100scannersdoor_module2","Verify adheader416 - 272x100scannersdoor_module2"
  end
end
