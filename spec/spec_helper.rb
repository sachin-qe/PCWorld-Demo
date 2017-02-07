require "rake"
require "selenium-webdriver"
require "Function_Library"
require "rspec"
require "fileutils"
require 'rest-client'

class Helper
  browser = ENV['browser']
  platform = ENV['platform']
  report_dir= ENV['report_dir']
  folderpath = ENV['folderpath']
    
  RSpec.configure do |config|
    config.before(:suite) do
      @tagname=ENV['module'] + '_' + ENV['env']
      @config = YAML.load_file(File.open(File.dirname(__FILE__) + '/../config/Environment.yml'))
      response=0
      $flag1 = 0
      begin
        response = Net::HTTP.get_response(URI("http://#{@config[@tagname]['baseurl']}"))  
      rescue Exception => e
        response = "400"
      end
      @desc_before =""
      if(response!="400")
        if((response.code.to_s.include?("40") != true || response.code.to_s.include?("50") != true))
          if(browser != "headless")
            $test =File.absolute_path(report_dir)
            $flag = 0 
            $test2 =File.absolute_path(folderpath).split(":").last
            $result = "#{$test}"+"#{$test2}"
            config.add_setting :selenium
            @obj = Function_Library.new
            @selenium = @obj.browser_setup(platform,browser)
            RSpec.configuration.selenium = @selenium
          end
        else
          $flag1 = 1
          print "<p>Server is Down config</p>"            
          exit 
        end 
      else 
        $flag1 = 1
        print "<p>Server is Down</p>"            
        exit
      end
    end

    config.after(:suite) do
      if(browser != "headless" && $flag1 == 0)
        @selenium = (RSpec.configuration.selenium)
        @selenium.quit
      end
    end

  end 
end # Class end