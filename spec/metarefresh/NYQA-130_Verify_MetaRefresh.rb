require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "rspec"

describe "Verify MetaRefresh on Homepage and Filter Pages" ,:critical => true do
  before(:all) do
    @lib_obj = Function_Library.new
    @config = @lib_obj.path_setup
    @base_url = "http://#{@config['baseurl']}"
  end  
    
  refs = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/Metarefresh_Link.yml'))

  refs.each do |meta|
    it "Verify Meta-refresh on Homepage #{meta['url']}" do
      @lib_obj.metarefresh_nokogiri("#{@base_url}"+"#{meta['url']}")
    end
  end
end # describe end
