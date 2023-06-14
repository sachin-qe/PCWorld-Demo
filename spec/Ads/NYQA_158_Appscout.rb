require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on Appscout page" ,:selenium => true,:retry => 3  do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @config = @lib_obj.path_setup
    @wait = @lib_obj.set_timeout(30)
    @base_url = "http://#{@config['baseurl2']}"
    @selenium.get(@base_url)
  end
  
  after(:all) do
   @selenium.get("#{@lib_obj.get_Base_URL}")
  end
  
  describe "Verify adheader 401- 728x90 - Displayed" ,:selenium => true do
    it"Verify adheader 401- 728x90 " do
      @lib_obj.check_ads_display("ad728x90appscoutdoor_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90appscoutdoor_ATF","Verify adheader 401- 728x90"
  end

  describe "Verify adheader 403- 300x250 - Displayed" ,:selenium => true do
    it"Verify adheader 403- 300x250 appscoutdoor_ATF  " do
      @lib_obj.check_ads_display("ad300x250appscoutdoor_ATF", 300, 250)
    end 
  end

  describe "Verify adheader 403- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250appscoutdoor_ATF","Verify adheader 403- 300x250"
  end

  describe "Verify adModule 403- 336x250 - Displayed" ,:selenium => true do
    it"Verify adModule ad403- ad336x250 appscoutdoor_module" do
      @lib_obj.check_ads_display("ad336x250appscoutdoor_module", 336, 250)
    end 
  end
  
  describe "Verify admodule 403- 336x250- tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250appscoutdoor_module","Verify adModule 403- 336x250"
  end

  describe "Verify adheader 405- 1x1 - Displayed" ,:selenium => true do
    it"Verify adheader 405- 1x1 " do
      @lib_obj.check_ads_display("ad1x1appscoutdoor_pixel", 1, 1)
    end
  end 

  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1appscoutdoor_pixel","Verify adheader 405- 1x1"
  end

  describe "Verify adheader 405- 1x2 - Displayed" ,:selenium => true do
    it"Verify adModule ad405 - 1x2 " do
      @lib_obj.check_ads_display("ad1x2appscoutdoor_special", 1, 2)
    end 
  end

  describe "Verify adheader 405- 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2appscoutdoor_special","Verify adheader 405- 1x2"
  end

  describe "Verify adModule 415- 300x250 - Displayed" ,:selenium => true do
    it "Verify adModule ad415 -300x250appscoutdoor_BTF  " do
      @lib_obj.check_ads_display("ad300x250appscoutdoor_BTF", 300, 250)
    end
  end

  describe "Verify adModule 415- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250appscoutdoor_BTF","Verify adModule 415- 300x250"
  end

  describe "Verify adheader 416- 272x100 - Displayed" ,:selenium => true do
    it "Verify adheader416 - 272x100 appscoutdoor_module2" do
      @lib_obj.check_ads_display("ad272x100appscoutdoor_module2", 272, 100)
    end
  end

  describe "Verify adheader 416- 272x100 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100appscoutdoor_module2","Verify adheader 416- 272x100"
  end
end #describe end