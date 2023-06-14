require 'rake'
require "selenium-webdriver"
require "Nokogiri_Library"
require "spec_helper"
require "open-uri"
require "Function_Library"
Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }

class SubCategory < TemplatePage 

  def test
    print "hello"
  end

end