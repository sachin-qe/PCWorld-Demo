require 'nokogiri'
require 'rest_client'
require 'yaml'
require 'rake'
require "selenium-webdriver"
require "Function_Library"
require 'open-uri'
require 'spec_helper'


describe "Verify Checking CSE links" do
  browser = ENV['browser']
  platform = ENV['platform']
  environment = ENV['env']

  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new    
    @base_url = @lib_obj.get_Base_URL
    @lib_obj.set_driver(@selenium)
    @lib_obj.waitforpagetoload
  end 

  refs = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/CSE_Link.yml'))

  refs.each do |info|
  	if("#{info['inline']}" == "true" && "#{info['bin']}" == "false")
	    describe "#{info['url']}  :#{info['description']} " do
	     it "Verify page loads without error " do
        @selenium.get("#{@base_url}#{info['url']}")
        if(browser == "ipad")
          @lib_obj.ipad_overlay_handle
        end         
       end

        it "Verify CSE inline tag -  title is not null " do
          $url = "#{@base_url}#{info['url']}"
          html_doc = @lib_obj.getPageSource
          $search_element = html_doc.xpath("//a[contains(@class,'zdcse') and not(contains(@title,'%seller%')) and not(@data-commerce-ziffcatid='0')]")
          $search_element[0].attribute('title').to_s.should_not == nil
        end

        it "Verify data-commerce-price is not null" do
          $search_element[0].attribute("data-commerce-price").to_s.should_not == nil
        end 

        it "Verify data-commerce-productname is not null" do
          $search_element[0].attribute("data-commerce-productname").to_s.should_not == nil
        end  
        
        it "Verify data-commerce-providerproductid is not null" do
          $search_element[0].attribute("data-commerce-providerproductid").to_s.should_not == nil
        end

        it "Verify data-commerce-vendor is not null" do
          $search_element[0].attribute("data-commerce-vendor").to_s.should_not == nil
        end
        
        it "Verify data-commerce-provider is not null" do
          $search_element[0].attribute("data-commerce-provider").to_s.should_not == nil
        end

        it "Verify data-commerce-manufacturer is not null" do
          $search_element[0].attribute("data-commerce-manufacturer").to_s.should_not == nil
        end

        it "Verify data-commerce-shipping  is not null" do
          $search_element[0].attribute("data-commerce-shipping").to_s.should_not == nil
        end
        
        it "Verify data-commerce-ziffcatid  is not null" do
          $data_commerce_ziffcatid = $search_element.attribute("data-commerce-ziffcatid")
          $data_affiliate_pcmag = $search_element.attribute("data-affiliate-pcmag")
          $search_element[0].attribute("data-commerce-ziffcatid").to_s.should_not == nil
        end
        
        it "Verify data-commerce-zifftaxid is not null" do
          $search_element[0].attribute("data-commerce-zifftaxid").to_s.should_not == nil
        end
        
        it "Verify data-commerce-guid is not null" do
          $search_element[0].attribute("data-commerce-guid").to_s.should_not == nil
        end

        it "Verify data-commerce-productid is not null" do          
          $search_element[0].attribute("data-commerce-productid").to_s.should_not == nil
        end

        it "Verify the <a> text </a> is not null" do          
          $search_element[0].text.should_not == nil
        end
        
        it "Verify call the JSON and ensure the best price matches" do
          # $data_affiliate_pcmag =  $search_element[0].attribute("data-affiliate-pcmag").to_s
          # cookie = @selenium.manage.cookie_named("_USERCOUNTRY6")
          # country = cookie[:value]
          if(environment == "staging")
            if($data_affiliate_pcmag == nil)
              @json_query = "http://qa.cse.adziff.com/CSE/BestPrice?ziffcatId=#{$data_commerce_ziffcatid}&co=US&referrer=www.pcmag.com&callback"
            else
              @json_query = "http://qa.cse.adziff.com/CSE/BestPrice?pcmagId=#{$data_affiliate_pcmag}&co=US&referrer=www.pcmag.com&callback"
            end
         else
           if($data_affiliate_pcmag == nil)
              @json_query = "http://cse.adziff.com/CSE/BestPrice?ziffcatId=#{$data_commerce_ziffcatid}&co=US&referrer=www.pcmag.com&callback"  
            else
              @json_query = "http://cse.adziff.com/CSE/BestPrice?pcmagId=#{$data_affiliate_pcmag}&co=US&referrer=www.pcmag.com&callback"
            end
            print @json_query
          end
          test = @lib_obj.readJSONresponse(@json_query)
          # split string to get displayed price 
          print $search_element[0].text
          actual_price = $search_element[0].text.split('"').last.split(" ").first
                    
          if(actual_price.include?("Best") == true)
            actual_price.should == "Best" 
          else
            actual_price.should == test.to_s.split('"Price":"').last.split('", "').first.split('"Price"=>"').last
          end          
        end
        
        it "Verify in page source, check for %seller% and %displayPrice% and see that it gets correctly converted to text in the HTML When the link/button is clicked" do
          string = $search_element[0].text
          string.include?("%displayPrice%").should_not == true
          string.include?("%seller%").should_not == true
        end

        it"Verify Open page with response code 200" do
          @lib_obj.verify_response_code(200).should be == true
        end       
      end
    end
  end
end
