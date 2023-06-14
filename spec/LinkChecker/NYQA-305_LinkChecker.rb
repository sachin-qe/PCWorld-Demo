require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "open-uri"

refs = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/PCMag_404_Link_Checker.yml'))

describe "Verify 404 response code for PCMag", :critical => true do
  # before(:all) do
  #   # @lib_obj = Function_Library.new
  #   # @config = @lib_obj.path_setup
  #   # @base_url = "http://#{@config.options['baseurl']}"
    
  # end
  
  it "Verify 404 for all links on the page" do
    for i in 0..refs.size-1
      begin
        url_response = Net::HTTP.get_response(URI.parse(refs[i]))
        if (url_response.code == "400" || url_response.code == "404" || url_response.code == "500")
          print "<p>"
          print url_response.code
          print " "
          print refs[i]
          print "</p>"
          print "\n"
        end
      rescue Exception => e
        print "<p>\n"
        print e.message
        print "</p>"
      end
    end # for loop ends
  end
end