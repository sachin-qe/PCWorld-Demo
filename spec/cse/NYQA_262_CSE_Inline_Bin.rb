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
  	if("#{info['inline']}" == "true" && "#{info['bin']}" == "true")
	    describe "#{info['url']}  :#{info['description']} " do
	      it "Verify Verify page loads without error " do
          @selenium.get("#{@base_url}#{info['url']}")
          if(browser == "ipad")
            @lib_obj.ipad_overlay_handle
          end         
        end

        it "Verify Verify CSE inline tag -  title is not null " do
          $url = "#{@base_url}#{info['url']}"
          html_doc = @lib_obj.getPageSource
          $element = html_doc.xpath("//a[contains(@class,'zdcse') and not(contains(@title,'%seller%')) and (@data-affiliate-pcmag)]")
          $element[0].attribute("title").to_s.should_not == nil
          print $element.size
          print $element[0].text
          $data_affiliate_pcmag = $element[0].attribute("data-affiliate-pcmag").to_s
          print $data_affiliate_pcmag
        end

        it "Verify Verify data-commerce-price is not null" do
          $element[0].attribute("data-commerce-price").to_s.should_not == nil
        end 

        it "Verify Verify data-commerce-productname is not null" do
          $element[0].attribute("data-commerce-productname").to_s.should_not == nil
        end  
        
        it "Verify data-commerce-providerproductid is not null" do
          $element[0].attribute("data-commerce-providerproductid").to_s.should_not == nil
        end

        it "Verify data-commerce-vendor is not null" do
          $element[0].attribute("data-commerce-vendor").to_s.should_not == nil
        end
        
        it "Verify data-commerce-provider is not null" do
          $element[0].attribute("data-commerce-provider").to_s.should_not == nil
        end

        it "Verify data-commerce-manufacturer is not null" do
          $element[0].attribute("data-commerce-manufacturer").to_s.should_not == nil
        end

        it "Verify data-commerce-shipping  is not null" do
          $element[0].attribute("data-commerce-shipping").to_s.should_not == nil
        end
        
        it "Verify data-commerce-ziffcatid  is not null" do
          $element[0].attribute("data-commerce-ziffcatid").to_s.should_not == nil
        end
        
        it "Verify data-commerce-zifftaxid is not null" do
          $element[0].attribute("data-commerce-zifftaxid").to_s.should_not == nil
        end
        
        it "Verify data-commerce-guid is not null" do
          $element[0].attribute("data-commerce-guid").to_s.should_not == nil
        end

        it "Verify data-commerce-productid is not null" do
          $element[0].attribute("data-commerce-productid").to_s.should_not == nil
        end

        it "Verify the <a> text </a> is not null" do
          $element[0].text.should_not == nil
        end
        
        it "Verify call the JSON and ensure the best price matches" do
          if(environment == "staging")
            @json_query = "http://qa.cse.adziff.com/CSE/BestPrice?pcmagId=#{$data_affiliate_pcmag}&co=US&referrer=www.pcmag.com&callback"
          else
            @json_query = "http://cse.adziff.com/CSE/BestPrice?pcmagId=#{$data_affiliate_pcmag}&co=US&referrer=www.pcmag.com&callback"
          end
          print @json_query
          test = @lib_obj.readJSONresponse(@json_query)
          $price = test.split('"Price":"').last.split('", "').first.split('"Price"=>"').last
          if($price.include?('\u') == true)
            $price = $price.gsub(/\\u[\da-f]{4}/i){ |m| [m[-4..-1].to_i(16)].pack('U') }
          end
          actual_price = $element[0].text.to_s.split('"').last.split(" ").first
          if(actual_price.include?('\u') == true)
            actual_price = $element[0].text.to_s.split('"').last.split(" ").first.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }   
          end
          actual_price.should == $price
        end
        
        it "Verify in page source, check for %seller% and %displayPrice% and see that it gets correctly converted to text in the HTML When the link/button is clicked" do
          string = $element[0].text
          string.include?("%displayPrice%").should_not == true
          string.include?("%seller%").should_not == true
        end

        it "Verify Open page with response code 200" do
          @lib_obj.verify_response_code(200).should be == true
        end

        it "Verify Click on link to check  CSE Bin Widget has at least one reference" do
          $element_scipt = @selenium.find_element(:css,".bin-data script").attribute("src")
          $element_tr = @selenium.find_elements(:css,".bin-data tr")
          @selenium.find_elements(:css,".bin-data tr").size.should > 0
        end
         
        it "Verify pcmagId is not null (save this for reference)" do
          $pcmag_id = $element_scipt.to_s.split("pcmagId=").last.split("&").first
          "#{$pcmag_id}".should_not == nil
        end

        it "Verify count is not null (save this for reference)" do
          $pcmag_count = $element_scipt[/#{"count="}(.*?)#{"&"}/m,1]
          $pcmag_count_integer = "#{$pcmag_count}".to_i  
          "#{$pcmag_count}".should_not == nil

        end

        it "Verify onload is not null" do
          $element_scipt.to_s[/#{"onload="}(.*?)#{"&"}/m,1].should_not == nil
        end 

        it "Verify freeShipping is not null" do
          $element_scipt.to_s[/#{"freeShipping="}(.*?)#{"&"}/m,1].should_not == nil
        end

        it "Verify lowPrice is not null" do
          $element_scipt.to_s[/#{"lowPrice="}(.*?)#{"&"}/m,1].should_not == nil 
        end

        it "Verify logo is not null" do
          $element_scipt.to_s.split("logo=").last.split('" type="').first.should_not == nil 
        end

        it "Verify <span class='pcmag-buyitnow-lowest-price-text'> has text" do
          @selenium.find_element(:css,"span.pcmag-buyitnow-lowest-price-text").text.should_not == nil    
        end

        it "Verify <span class='pcmag-buyitnow-lowest-price-value'> has text" do
          @selenium.find_element(:css,"span.pcmag-buyitnow-lowest-price-value").text.should_not == nil
        end

        it "Verify data-commerce-guid is not null" do
          $element_tr[0].attribute('data-commerce-guid').to_s.should_not == nil
        end

        it "Verify data-commerce-zifftaxid is not null" do
          $element_tr[0].attribute('data-commerce-zifftaxid').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-ziffcatid is not null" do
          $element_tr[0].attribute('data-commerce-ziffcatid').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-manufacturer is not null" do
          $element_tr[0].attribute('data-commerce-manufacturer').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-provider is not null" do
          $element_tr[0].attribute('data-commerce-provider').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-vendor is not null" do
          $element_tr[0].attribute('data-commerce-vendor').to_s.should_not == nil  
        end

        it "Verify data-commerce-providerproductid is not null" do
          $element_tr[0].attribute('data-commerce-providerproductid').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-productname is not null" do
          $element_tr[0].attribute('data-commerce-productname').to_s.should_not == nil  
        end
        
        it "Verify data-commerce-price is not null" do
          $element_tr[0].attribute('data-commerce-price').to_s.should_not == nil  
        end

        it "Verify <td class='pcmag-buyitnow-logo'> has text" do
          @selenium.find_element(:css,"td.pcmag-buyitnow-logo").text.should_not == nil
        end
        
        it "Verify <td class='pcmag-buyitnow-price'> has text" do
          @selenium.find_element(:css,"td.pcmag-buyitnow-logo").text.should_not == nil
        end

        it "Verify <td class='pcmag-buyitnow-buybutton>' exist " do
          @selenium.find_element(:css,"td.pcmag-buyitnow-buybutton").displayed?.should == true
        end

        it "Verify the number of rows in the BIN widget should match the count(saved above from script src)" do
          $count =  $element_tr.size
          $element_tr.size > 0
          $element_tr.size.should <= $pcmag_count_integer
        end

        it "Verify call the JSON and and ensure all the top prices match " do
          # cookie = @selenium.manage.cookie_named("_USERCOUNTRY6")
          # country = cookie[:value]
          if(environment == "staging")
            @json_query = "http://qa.cse.adziff.com/CSE/BestPrice?pcmagId=#{$pcmag_id}&count=#{$pcmag_count}&co=US&referrer=www.pcmag.com&callback"
            test = @lib_obj.readJSONresponse(@json_query)
          else
            @json_query = "http://cse.adziff.com/CSE/BestPrice?pcmagId=#{$pcmag_id}&count=#{$pcmag_count}&co=US&referrer=www.pcmag.com&callback"
            test = @lib_obj.readJSONresponse(@json_query)
          end
          array = Array.new
          array = test.split('OpenHtml":"',$count)
          for i in 0..$count
            if(i == $count)
              break
            end
            @subelement = $element_tr[i].find_element(:xpath,".//td[2]")
            if(@subelement.text.include?("FREE SHIPPING") == true)
              @subelement.text.split(" ").first.to_s.should == (array[i][/#{'"Price"=>"'}(.*?)#{'", "'}/m,1]).to_s
            else
              @subelement.text.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }.should == (array[i][/#{'"Price"=>"'}(.*?)#{'", "'}/m,1]).to_s.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') } 
            end
          end
        end
      end
    end
  end
end
