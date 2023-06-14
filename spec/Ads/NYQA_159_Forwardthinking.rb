require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on Forward Thinking page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("http://www.forwardthinking.pcmag.com/")
  end  

  describe "Verify adheader 401- 728x90 - Displayed" ,:selenium => true do
    it "Verify adheader 401- size should be 728x90" do
      @lib_obj.check_ads_display("ad728x90forwardthinkingdoor_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90forwardthinkingdoor_ATF","Verify adheader 401- 728x90"
  end

  describe "Verify adheader 403- 300x250 - Displayed" ,:selenium => true do
    it "Verify adheader 403 - 300x250forwardthinkingdoor_ATF" do
      @lib_obj.check_ads_display("ad300x250forwardthinkingdoor_ATF", 300, 250)
    end
  end

  describe "Verify adheader 403- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250forwardthinkingdoor_ATF","Verify adheader 403- 300x250"
  end

  describe "Verify adheader 403- 336x250 - Displayed" ,:selenium => true do
    it "Verify adModule ad403 - ad336x250forwardthinkingdoor_module" do
      @lib_obj.check_ads_display("ad336x250forwardthinkingdoor_module", 336, 250)
    end
  end

  describe "Verify adheader 403- 336x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250forwardthinkingdoor_module","Verify admodule 403- 336x250"
  end      

  describe "Verify adheader 405- 1x1 - Displayed" ,:selenium => true do
    it "Verify adheader 405 - 1x1" do
      @lib_obj.check_ads_display("ad1x1forwardthinkingdoor_pixel", 1, 1)
    end
  end

  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1forwardthinkingdoor_pixel","Verify adheader 405- 1x1"
  end      

  describe "Verify admodule 405- 1x2 - Displayed" ,:selenium => true do
    it "Verify adModule ad405 - 1x2" do
      @lib_obj.check_ads_display("ad1x2forwardthinkingdoor_special", 1, 2)
    end
  end
  
  describe "Verify admodule 405- 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2forwardthinkingdoor_special","Verify admodule 405- 1x2"
  end           

  describe "Verify admodule 415- 300x250 - Displayed" ,:selenium => true do
    it "Verify adModule ad415 - 300x250forwardthinkingdoor_BTF" do
      @lib_obj.check_ads_display("ad300x250forwardthinkingdoor_BTF", 300, 250)
    end
  end

  describe "Verify admodule 415- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250forwardthinkingdoor_BTF","Verify admodule 415- 300x250"
  end      

  describe "Verify adheader416 - 272x100 - Displayed" ,:selenium => true do
    it "Verify adheader416 - 272x100forwardthinkingdoor_module2" do
      @lib_obj.check_ads_display("ad272x100forwardthinkingdoor_module2", 272, 100)
    end
  end

  describe "Verify adheader416 - 272x100 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100forwardthinkingdoor_module2","Verify adheader 416 - 272x100"
  end
end # Outer Describe end  
