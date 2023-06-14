require 'Function_Library'
require 'selenium-webdriver'
require 'rake'
require 'yaml'

refs = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/Canonicals_Link.yml'))

describe "Verify Canonicals on PCMag" ,:critical => true do
  before(:all) do
    @lib_obj = Function_Library.new
    @config = @lib_obj.path_setup
    @base_url = "http://#{@config['baseurl']}"
    print @base_url
  end  

  refs.each do |info|
    it "Verify canonical homepage#{info['url']}" do
      if("#{info['pending']}" != "true")      
        @lib_obj.canonicals_nokogiri("#{@base_url}#{info['url']}", "#{@base_url}#{info['href']}")
      else
        pending("Known issue")do
          this_should_not_get_executed 
          @lib_obj.canonicals_nokogiri("#{@base_url}#{info['url']}", "#{@base_url}#{info['href']}")
        end
      end
    end
  end
end # describe end
