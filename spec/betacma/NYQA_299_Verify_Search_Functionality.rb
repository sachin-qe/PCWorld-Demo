require "rake"
require "selenium-webdriver"
require "Function_Library"
require "yaml"
require "rest-client"

describe "Verify Search Article functionality"  do
  browser = ENV['browser']  

  before(:all) do
    @driver = RSpec.configuration.selenium
    @lib_obj=Function_Library.new
    @lib_obj.set_driver(@driver)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    @betacma =YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/betacma.yml'))
    @driver.find_element(:css,"input[name='username']").send_keys(@betacma['Login']['Username'])
    @driver.find_element(:css,"input[name='password']").send_keys(@betacma['Login']['Password'])
    @lib_obj.clickandwait(@driver.find_element(:css,"input[class='login']"))
    @lib_obj.clickandwait(@driver.find_element(:xpath,"//a[.='Article']"))
  end
  
  it "Verify HTTP response is 200 " do
    RestClient.get(@driver.current_url).code.should == 200
  end
  
  it "Verify Goes to http://betacma.nyq.ziffdavisinet.com/Article.aspx/Index " do
    @driver.current_url.should include "#{@lib_obj.get_Base_URL}" + "/Article.aspx/Index"
  end

  it "Verify header exists" do
    @driver.find_element(:css,"div[class='globalheader']").displayed?.should == true
  end

  it "Verify CMA Navigation block exists" do
    @driver.find_element(:css,".cma-navigation").displayed?.should == true
  end

  it "Verify the Search panel exists" do
    @driver.find_element(:css,"#global-index").displayed?.should == true 
  end
  
  it "Verify Search Result Display block exists" do
    @driver.find_element(:css,".indexView").displayed?.should == true 
  end

  describe "Verify the following search fields exist" do
    it "ID(s): Textbox exists " do
      @driver.find_element(:css,"input[id='IDs']").displayed?.should == true
    end

    it " Verify Author: Textbox exists and when user enters data, it should display dropdown" do
      @driver.find_element(:css,"input[id*='AuthorLastName2-t-0']").displayed?.should == true
      @driver.find_element(:css,"input[id*='AuthorLastName2-t-0']").send_keys("a")
      @wait.until{@driver.find_element(:xpath,"//ul[2]").displayed? == true}
      options = @driver.find_elements(:xpath,"//ul[2]/li/a")
      options[2].click
      @driver.find_element(:css,"input[id*='AuthorLastName2-t-0']").attribute("value").to_s.should == options[2].attribute("text").to_s
    end

    it "Verify Delete Icon must exists beside the textbox. When clicked it must delete the value from Author textbox" do
      deleteicon = @driver.find_element(:css,"ul[id='AuthorLastName2'] a img[title='Clear this value.']")
      deleteicon.displayed?.should == true
      deleteicon.click
      @driver.find_element(:css,"input[id*='AuthorLastName2-t-0']").attribute("value").to_s.should == ""
    end
    
    it "Verify Title: Textbox exist" do
      @driver.find_element(:css,"input[id='Title']").displayed?.should == true
    end

    it "Verify Web Site: Dropdown exists" do
      @driver.find_element(:css,"select[id='WebSite']").displayed?.should == true
    end
    
    it "Verify Start Date: Textbox exists" do
      @driver.find_element(:css,"input[id='Startdate']").displayed?.should == true
    end
    
    it "Verify End Date: Textbox exists" do
      @driver.find_element(:css,"input[id='EndDate']").displayed?.should == true
    end
    
    it "Verify Section: Textbox existswhen user enters data, it should display dropdown" do
      @driver.find_element(:css,"input[id*='PrimarySection4-t-0']").displayed?.should == true
      @driver.find_element(:css,"input[id*='PrimarySection4-t-0']").send_keys("home")
      @wait.until{@driver.find_element(:xpath,"//ul[4]").displayed? == true}
      options = @driver.find_elements(:xpath,"//ul[4]/li/a")
      options[2].click
      @driver.find_element(:css,"input[id*='PrimarySection4-t-0']").attribute("value").to_s.should == options[2].attribute("text").to_s
    end
    
    it "Verify Delete Icon must exists beside the textbox. When clicked it must delete the value from Section textbox" do
      deleteicon = @driver.find_element(:css,"ul[id='PrimarySection4'] a img[title='Clear this value.']")
      deleteicon.displayed?.should == true
      deleteicon.click
      @driver.find_element(:css,"input[id*='PrimarySection4-t-0']").attribute("value").to_s.should == ""
    end
    
    it "Verify Created By: Textbox  exists" do
      @driver.find_element(:css,"input[id='CreatedBy']").displayed?.should == true
    end
    
    it "Verify Content Type: Dropdown  exists" do
      @driver.find_element(:css,"select[id='ContentType']").displayed?.should == true
    end
    
    it "Verify  Print Issue: Textbox with Dropdown button exists and User should be able to select a value from the dropdown" do
      @driver.find_element(:css,"input[id*='PrintIssue6-t-0']").displayed?.should == true
      @driver.find_element(:css,"input[id*='PrintIssue6-t-0']").send_keys("vol")
      @wait.until{@driver.find_element(:xpath,"//ul[6]").displayed? == true}
      options = @driver.find_elements(:xpath,"//ul[6]/li/a")
      options[2].click
      @driver.find_element(:css,"input[id*='PrintIssue6-t-0']").attribute("value").to_s.should == options[2].attribute("text").to_s
    end
    
    it "Verify Delete Icon must exists beside the textbox. When clicked it must delete the value from Print dropdown" do
      deleteicon = @driver.find_element(:css,"ul[id='PrintIssue6'] a img[title='Clear this value.']")
      deleteicon.displayed?.should == true
      deleteicon.click
      @driver.find_element(:css,"input[id*='PrintIssue6-t-0']").attribute("value").to_s.should == ""
    end

    it "Verify Result per page: Dropdown exists and By default 100 should be selected" do
      resultdropdown = @driver.find_element(:css,"select[id='ResultsPerPage']")
      resultdropdown.displayed?.should == true
      resultdropdown.find_element(:css,"option[selected='selected']").text.should == "100"
    end
    
    it "Verify Status: Dropdown exists and By default (all) should be selected" do
      status = @driver.find_element(:css,"select[id='State']")
      status.displayed?.should == true
      status.find_element(:xpath,"//option[contains(.,'(all)')]").attribute('selected').should == "true"
    end
    
    it "Verify Search button must exists"do
      @driver.find_element(:css,"input[name='Search']").displayed?.should == true
    end
  end

  describe"Verify the following search combinations" do
    it "Click on the Search button (without entering any details in the search fields)" do
      #Click on search
      @lib_obj.clickandwait(@driver.find_element(:css,"input[name='Search']"))
      # Result list view must be populated with results 
      @driver.find_elements(:css,".indexTable tr").size.should be >= 1
      # Max 100 Articles are displayed 
      @driver.find_elements(:css,".indexTable tr a[data_deck]").size.should >= 100
    end

    it "Searching with one search value" do
      # Enter Value of Author and set result as 10
      @lib_obj.selectDropdownOption(@driver.find_element(:css,"#ResultsPerPage"),"10")
      @driver.find_element(:css,"input[id*='AuthorLastName2-t-0']").send_keys(" Dan")
      @wait.until{@driver.find_element(:xpath,"//ul[2]").displayed? == true}
      options = @driver.find_elements(:xpath,"//ul[2]/li/a")
      options[0].click
      # sleep 3
      @lib_obj.clickandwait(@driver.find_element(:css,"input[name='Search']"))
      @driver.find_elements(:xpath,"//tr/td[contains(.,'Dan   Costa')]").size.should == 10
      @driver.find_elements(:css,".indexTable tr a[data_deck]").size.should == 10
    end
    
     it "Searching with Multiple search value" do
      # Enter Value of Multiple field
      @lib_obj.selectDropdownOption(@driver.find_element(:css,"#ContentType"),"Standard Article")
      @lib_obj.selectDropdownOption(@driver.find_element(:css,"#State"),"Published")
      @lib_obj.clickandwait(@driver.find_element(:css,"input[name='Search']"))
      @driver.find_elements(:xpath,"//tr/td[contains(.,'Standard Article')]").size.should == 10
      @driver.find_elements(:xpath,"//tr/td[contains(.,'Published')]").size.should == 10
      @driver.find_elements(:css,".indexTable tr a[data_deck]").size.should == 10
    end
    
    describe "Verify in the Search Result Display block/grid" do
      it " ID, Title, Created, Author, Section, Article Type, Status, Publish Date" do
        @driver.find_element(:xpath,"//a[contains(.,'ID')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Title')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Created')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Author')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Section')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'ArticleType')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Status')]").displayed?.should == true
        @driver.find_element(:xpath,"//a[contains(.,'Publish Date')]").displayed?.should == true  
      end

      it"Verify Pagination feature" do
        element = @driver.find_elements(:css,".page-num span").first
        pages = element.find_elements(:tag_name,"a").size
        for i in 1..pages-1
          @lib_obj.clickandwait(@driver.find_element(:css,"a[href*='pageNum=#{i+1}']"))
          @driver.find_elements(:xpath,"//div[@class='result-page']/span[contains(.,'Page: ') and not (contains(.,'Results'))]").first.text.split(": ").last.should == "#{i+1}"
        end
        #click on first page
        @lib_obj.clickandwait(@driver.find_element(:xpath,"//a[contains(.,'1') and not (contains(.,'pageNum='))]"))
      end

      it"When clicked on Title link, user must be redirected to the CMA's Article page"do
        article_title = @driver.find_elements(:css,"a[href*='/Article.aspx/Edit?id=']").first.text 
        @driver.find_elements(:css,"a[href*='/Article.aspx/Edit?id=']").first.click
        @driver.find_element(:css,".articleid h3").text.include?("#{article_title}").should == true
      end
    end
  end
end
