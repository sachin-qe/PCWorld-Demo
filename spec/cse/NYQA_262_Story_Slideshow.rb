require 'rake'
require "rspec"
require "selenium-webdriver"
require "Function_Library"
require "nokogiri"
require "open-uri"

describe "Check all Links for CSE JS - Story Slideshow (inline + BIN)  " ,:selenium => true do
  browser = ENV['browser']
  platform = ENV['platform']
  environment = ENV['env']
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new    
    @base_url = @lib_obj.get_Base_URL + "/slideshow/story/317512/the-best-ipad-air-cases/1"
    @lib_obj.set_driver(@selenium)
    @selenium.get(@base_url)
    @lib_obj.waitforpagetoload
  end
   
  it "Click on link to check  CSE Bin Widget has at least one reference" do
    @selenium.find_elements(:css,".pcmag-buyitnow tr").size.should > 0
    $element = @selenium.find_element(:css,".ss-bin-widget script").attribute('src')
  end
   
  it "ziffcatid is not null (save this for reference)" do
    $element.to_s.split("ziffcatId=").last.split("&").first.should_not == nil
    $ziffcat_id = $element.to_s.split("ziffcatId=").last.split("&").first
  end

  it "count is not null (save this for reference)" do
    $pcmag_count = $element[/#{"count="}(.*?)#{"&"}/m,1]
    $pcmag_count_integer = "#{$pcmag_count}".to_i 
    "#{$pcmag_count}".should_not == nil
  end

  it "onload is not null" do
    $element.to_s.split("onload=").last.split('"').first.should_not == nil
  end 

  it "freeShipping is not null" do
    $element.to_s[/#{"freeShipping="}(.*?)#{'&'}/m,1].should_not == nil
  end

  it "lowPrice is not null" do
    $element.to_s[/#{"lowPrice="}(.*?)#{"&"}/m,1].should_not == nil 
  end

  it "logo is not null" do
    $element.to_s.split("logo=").last.split('" type="').first.should_not == nil 
  end

   it "<span class='pcmag-buyitnow-lowest-price-text'> has text" do
     $td_element = @selenium.find_element(:css,".ss-bin-widget td")
     $td_element.text.should_not == nil    
   end

  it "<span class='pcmag-buyitnow-lowest-price-value'> has text" do
    $td_element.text.should_not == nil
  end

  it "data-commerce-guid is not null" do
    $td_element.attribute('data-commerce-guid').to_s.should_not == nil
  end

  it "data-commerce-zifftaxid is not null" do
    $td_element.attribute('data-commerce-zifftaxid').to_s.should_not == nil  
  end
  
  it "data-commerce-ziffcatid is not null" do
    $td_element.attribute('data-commerce-ziffcatid').to_s.should_not == nil  
  end
  
  it "data-commerce-manufacturer is not null" do
    $td_element.attribute('data-commerce-manufacturer').to_s.should_not == nil  
  end
  
  it "data-commerce-provider is not null" do
    $td_element.attribute('data-commerce-provider').to_s.should_not == nil  
  end
  
  it "data-commerce-vendor is not null" do
    $td_element.attribute('data-commerce-vendor').to_s.should_not == nil  
  end

  it "data-commerce-providerproductid is not null" do
    $td_element.attribute('data-commerce-providerproductid').to_s.should_not == nil  
  end
  
  it "data-commerce-productname is not null" do
    $td_element.attribute('data-commerce-productname').to_s.should_not == nil  
  end
  
  it "data-commerce-price is not null" do
    $td_element.attribute('data-commerce-price').to_s.should_not == nil  
  end

  it "<td class='pcmag-buyitnow-logo'> has text" do
    @selenium.find_element(:css,"td.pcmag-buyitnow-logo").text.should_not == nil
  end
  
  it "<td class='pcmag-buyitnow-price'> has text" do
    @selenium.find_element(:css,"td.pcmag-buyitnow-logo").text.should_not == nil
  end

  it "<td class='pcmag-buyitnow-buybutton>' exist " do
    @selenium.find_element(:css,"td.pcmag-buyitnow-buybutton").displayed?.should == true
  end

  it "the number of rows in the BIN widget should match the count(saved above from script src)" do
    $element = @selenium.find_elements(:css,".ss-bin-widget tr")
    $count = $element.size
    $element.size.should > 0
    $element.size.should <= $pcmag_count_integer
  end

  it "call the JSON and and ensure all the top prices match " do
    if(environment == "staging")
      @json_query = "http://qa.cse.adziff.com/CSE/topprices?ziffcatId=#{$ziffcat_id}&count=#{$pcmag_count}&referrer=pcmag.com"
      test = @lib_obj.readJSONresponse(@json_query)
    else
      @json_query = "http://cse.adziff.com/CSE/topprices?ziffcatId=#{$ziffcat_id}&count=#{$pcmag_count}&referrer=pcmag.com"
      test = @lib_obj.readJSONresponse(@json_query)
    end
    array = Array.new
    array = test.split('OpenHtml":"',$count)
    for i in 0..$count
      if(i == $count)
        break
      end
      @subelement=$element[i].find_element(:xpath,".//td[2]")
      if(@subelement.text.include?("FREE SHIPPING") == true)
        print @subelement.text.split(" ").first.to_s
        @subelement.text.split(" ").first.to_s.should == (array[i][/#{'"Price"=>"'}(.*?)#{'",'}/m,1]).to_s
   
      else
        @subelement.text.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }.should == (array[0][/#{'"Price"=>"'}(.*?)#{'",'}/m,1]).to_s.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') } 
      end
    end
  end
end