require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require "spec_helper"
Dir[File.dirname(__FILE__) + '/../../pages/geek/*.rb'].each {|file| require file }

describe "Verify page -Videos are Playable" ,:selenium => true do
  before(:all) do
    @selenium = RSpec.configuration.selenium
    @lib_obj = Function_Library.new
    @lib_obj.set_driver(@selenium)    
    @wait = @lib_obj.set_timeout(30)
    @base_url1 = "#{@lib_obj.get_Base_URL}/news/turkish-drone-shooting-heralds-a-new-age-of-civillian-counter-surveillance-1559279/"
    @base_url2 = "#{@lib_obj.get_Base_URL}/review/qi-wireless-charger-roundup-1559228/"
  end  
  
  after(:all) do
    @lib_obj.open_homepage
  end
  
  it "Verify Page loads with no error" do
    @selenium.get(@base_url1)
  end
   
  it "Verify Open page with response code 200 " do
    @lib_obj.verify_response_code(200).should == true
  end
  
  it "Verify Videos are playable" do
    @selenium.switch_to.frame(@selenium.find_element(:css,"iframe[src*='http://player.vimeo.com/video/68156381?']"))
    sleep (1)
    @selenium.execute_script("document.getElementById('player').scrollIntoView()")
    element1=@selenium.find_element(:class,"controls")
    progress_before = @selenium.find_element(:css,".played").attribute("aria-valuenow")
    @selenium.find_element(:css,"button[title='Play']").click
    sleep(4)
    # @wait.until{element1.find_element(:css,".loaded").attribute("aria-valuenow") == element1.find_element(:css,".loaded").attribute("aria-valuemax") } 
    progress_after = element1.find_element(:css,".played").attribute("aria-valuenow")
    progress_before.should be < progress_after
  end
  
  it "Verify Page loads with no error" do
    @selenium.get(@base_url2)
  end

  it "Verify Open page with response code 200 " do
    @lib_obj.verify_response_code(200).should == true
  end
 
  it "Verify Videos are playable" do
    @selenium.switch_to.frame(@selenium.find_element(:xpath,"/html/body/section/section/section[2]/div[4]/div/article/p[3]/iframe"))
    @selenium.execute_script("document.getElementById('player').scrollIntoView()")
    sleep(5)
    @selenium.execute_script("var movie = window.document.getElementById('player1');movie.playVideo();")
    @wait.until{@selenium.execute_script("var movie = window.document.getElementById('player1');return movie.getPlayerState();") == 1}
    playerstatus=@selenium.execute_script("var movie = window.document.getElementById('player1');return movie.getPlayerState();")
    playerstatus.should be == 1 
  end
end
