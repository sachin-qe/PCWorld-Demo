require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "yaml"

@url_check = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/URLCheck.yml'))
$artcile_check = @url_check['Artcile_Id']['artcile_id']
$refs = @url_check[$artcile_check].to_a 

describe "Create New Review article", :selenium => true do
  browser = ENV['browser']  
  
  before(:all) do
    @driver = RSpec.configuration.selenium
    @lib_obj=Function_Library.new
    @lib_obj.set_driver(@driver)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 50)
    @solr =YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/Solr.yml'))
    @article = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/ArticleData.yml'))
  end

  $refs.each do |a|
    it" Verify article is displayed on #{a} " do
      @driver.get(a)
      @driver.find_element(:xpath,"//a[.='#{@article[$artcile_check]['Article_title']}']").displayed? == true
    end
  end
end