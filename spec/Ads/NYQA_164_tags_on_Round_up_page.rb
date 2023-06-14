require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "rspec"
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on Round up page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("#{@lib_obj.get_Base_URL}/article2/0,2817,2369981,00.asp")
  end

  describe "Verify adheader 401- 728x90 - Displayed" ,:selenium => true do
    it"Verify adheader 401- 728x90 " do
      @lib_obj.check_ads_display("ad728x90laptopssection_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90laptopssection_ATF","Verify adheader 401- 728x90"
  end

  describe "Verify adheader 403- 300x250 - Displayed" ,:selenium => true do
    it"Verify adheader 403- 300x250 laptopssection_ATF  " do
      @lib_obj.check_ads_display("ad300x250laptopssection_ATF", 300, 250)
    end 
  end

  describe "Verify adheader 403- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250laptopssection_ATF","Verify adheader 403- 300x250"
  end

  describe "Verify adModule 403- 336x250 - Displayed" ,:selenium => true do
    it"Verify adModule ad403- ad336x250 laptopssection_module" do
      @lib_obj.check_ads_display("ad336x250laptopssection_module", 336, 250)
    end 
  end
  
  describe "Verify admodule 403- 336x250- tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250laptopssection_module","Verify adModule 403- 336x250"
  end

  describe "Verify adheader 405- 1x1 - Displayed" ,:selenium => true do
    it"Verify adheader 405- 1x1 " do
      @lib_obj.check_ads_display("ad1x1laptopssection_pixel", 1, 1)
    end
  end 

  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1laptopssection_pixel","Verify adheader 405- 1x1"
  end

  describe "Verify adheader 405- 1x2 - Displayed" ,:selenium => true do
    it"Verify adModule ad405 - 1x2 " do
      @lib_obj.check_ads_display("ad1x2laptopssection_special", 1, 2)
    end 
  end

  describe "Verify adheader 405- 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2laptopssection_special","Verify adheader 405- 1x2"
  end
 
  describe "Verify admodule 411- 1x3 - Displayed" ,:selenium => true do
    it"Verify adModule ad411- 1x3 " do
      @lib_obj.check_ads_display("ad1x3laptopssection_exotic", 1, 3)
    end 
  end 

  describe "Verify adModule 411- 1x3 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x3laptopssection_exotic","Verify adModule 411- 1x3"
  end

  describe "Verify adModule 414- 728x90 - Displayed" ,:selenium => true do
    it "Verify adModule ad414 - 728x90laptopssection_BTF (mostly bottom of article pages) " do
      @lib_obj.check_ads_display("ad728x90laptopssection_BTF", 728, 90)
    end
  end
 
  describe "Verify adModule 414- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90laptopssection_BTF","Verify adModule 414- 728x90"
  end

  describe "Verify adModule 415- 300x250 - Displayed" ,:selenium => true do
    it "Verify adModule ad415 -300x250laptopssection_BTF  " do
      @lib_obj.check_ads_display("ad300x250laptopssection_BTF", 300, 250)
    end
  end

  describe "Verify adModule 415- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250laptopssection_BTF","Verify adModule 415- 300x250"
  end

  describe "Verify adheader 416- 272x100 - Displayed" ,:selenium => true do
    it "Verify adheader416 - 272x100 laptopssection_module2" do
      @lib_obj.check_ads_display("ad272x100laptopssection_module2", 272, 100)
    end
  end

  describe "Verify adheader 416- 272x100 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100laptopssection_module2","Verify adheader 416- 272x100"
  end
end #describe end
