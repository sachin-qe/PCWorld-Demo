require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "rspec"
require 'Example_Group'
require "spec_helper"

describe "Verify Ads tags on News article page" ,:selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)
    @wait = @lib_obj.set_timeout(30)
    @selenium.get("#{@lib_obj.get_Base_URL}/article2/0,2817,2424828,00.asp")
  end 

  describe "Verify adheader 401- 728x90 - Displayed" ,:selenium => true do
    it"Verify adheader 401- 728x90 " do
      @lib_obj.check_ads_display("ad728x90tabletssection_ATF", 728, 90)
    end
  end

  describe "Verify adheader 401- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90tabletssection_ATF","Verify adheader 401- 728x90"
  end

  describe "Verify adheader 403- 300x250 - Displayed" ,:selenium => true do
    it"Verify adheader 403- 300x250 tabletssection_ATF  " do
      @lib_obj.check_ads_display("ad300x250tabletssection_ATF", 300, 250)
    end 
  end
  
  describe "Verify adheader 403- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250tabletssection_ATF","Verify adheader 403- 300x250"
  end
  
  describe "Verify adModule 403- 336x250 - Displayed" ,:selenium => true do
    it"Verify adModule ad403- ad336x250 tabletssection_module" do
      @lib_obj.check_ads_display("ad336x250tabletssection_module", 336, 250)
    end 
  end
  
  describe "Verify admodule 403- 336x250- tags" ,:selenium => true do
    include_examples "Check Tags","ad336x250tabletssection_module","Verify adModule 403- 336x250"
  end
  
  describe "Verify adheader 405- 1x1 - Displayed" ,:selenium => true do
    it"Verify adheader 405- 1x1 " do
      @lib_obj.check_ads_display("ad1x1tabletssection_pixel", 1, 1)
    end
  end 
  
  describe "Verify adheader 405- 1x1 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x1tabletssection_pixel","Verify adheader 405- 1x1"
  end
  
  describe "Verify adheader 405- 1x2 - Displayed" ,:selenium => true do
    it"Verify adModule ad405 - 1x2 " do
      @lib_obj.check_ads_display("ad1x2tabletssection_special", 1, 2)
    end 
  end
  
  describe "Verify adheader 405- 1x2 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x2tabletssection_special","Verify adheader 405- 1x2"
  end
  
  describe "Verify admodule 411- 1x3 - Displayed" ,:selenium => true do
    it"Verify adModule ad411- 1x3 " do
      @lib_obj.check_ads_display("ad1x3tabletssection_exotic", 1, 3)
    end 
  end 
  
  describe "Verify adModule 411- 1x3 - tags" ,:selenium => true do
    include_examples "Check Tags","ad1x3tabletssection_exotic","Verify adModule 411- 1x3"
  end
  
  describe "Verify adModule 414- 728x90 - Displayed" ,:selenium => true do
    it "Verify adModule ad414 - 728x90tabletssection_BTF (mostly bottom of article pages) " do
      @lib_obj.check_ads_display("ad728x90tabletssection_BTF", 728, 90)
    end
  end
  
  describe "Verify adModule 414- 728x90 - tags" ,:selenium => true do
    include_examples "Check Tags","ad728x90tabletssection_BTF","Verify adModule 414- 728x90"
  end
  
  describe "Verify adModule 415- 300x250 - Displayed" ,:selenium => true do
    it "Verify adModule ad415 -300x250tabletssection_BTF  " do
      @lib_obj.check_ads_display("ad300x250tabletssection_BTF", 300, 250)
    end
  end
  
  describe "Verify adModule 415- 300x250 - tags" ,:selenium => true do
    include_examples "Check Tags","ad300x250tabletssection_BTF","Verify adModule 415- 300x250"
  end
  
  describe "Verify adheader 416- 272x100 - Displayed" ,:selenium => true do
    it "Verify adheader416 - 272x100 tabletssection_module2" do
      @lib_obj.check_ads_display("ad272x100tabletssection_module2", 272, 100)
    end
  end
  
  describe "Verify adheader 416- 272x100 - tags" ,:selenium => true do
    include_examples "Check Tags","ad272x100tabletssection_module2","Verify adheader 416- 272x100"
  end
end #describe end
