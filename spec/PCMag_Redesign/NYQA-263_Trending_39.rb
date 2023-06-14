require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
require "Nokogiri_Library"
require "open-uri"

describe "Verify Trending right rail widget has article titles" , :selenium => true,:retry => 3 do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @Nokogiri = Nokogiri_Library.new
    @lib_obj.set_driver(@selenium)
    @Nokogiri.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @lib_obj.open_homepage
  end
  
  it "Verify Trending right rail should not be empty" do
    @Nokogiri.getSize("css","div#news-stack>ul>li").should >= 1
    # To get number of titles
    @no_of_titles = @Nokogiri.getSize("css","div#news-stack>ul>li")
    # To define array for font-size of titles
    font_size_array = Array.new(@no_of_titles)
    # To Check that all stories exist
    for i in 1..@no_of_titles
      @title = @selenium.find_element(:css, "#trending#{i} a")
      @title.displayed?.should be == true
      @title.text.should_not == nil
      #Assigning sizes as element of array
      font_size_array[i] = @title.style("font-Size").chomp('px')
    end

    for i in 1..@no_of_titles
      #To Check that third article is larger than any other
      (font_size_array[i] <= font_size_array[3]).should be == true
    end
  end
end # Describe ends
