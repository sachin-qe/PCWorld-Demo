require "rake"
require "selenium-webdriver"
require "Function_Library"
require "spec_helper"
require "yaml"


describe "Create New Review article", :cma => true do
  browser = ENV['browser']  

  before(:all) do
    @driver = RSpec.configuration.selenium
    @lib_obj=Function_Library.new
    @lib_obj.set_driver(@driver)
    @wait = Selenium::WebDriver::Wait.new(:timeout => 50)

    @solr =YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/Solr.yml'))
    @product = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/ProductData.yml'))
    @article = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/ArticleData.yml'))
    @url_check = YAML.load_file(File.open(File.dirname(__FILE__) + '/../../config/URLCheck.yml'))
    a=Random.rand(1...10)
    @data = "Data_#{a}"
    @article_data = "Article_#{a}"
    @url_check['Artcile_Id']['artcile_id'] = @article_data
    File.open(File.dirname(__FILE__) + '/../../config/URLCheck.yml','w') {|f| f.write @url_check.to_yaml }
  end
  
  it "Add Product And Save" do
    
    @driver.find_element(:css,"input[name='userid']").send_keys(@solr['Login']['Username'])
    @driver.find_element(:css,"input[name='passwd']").send_keys(@solr['Login']['Password'])
    @lib_obj.clickandwait(@driver.find_element(:css,"input[type='submit']"))
    #Create new Product
    @wait.until{@driver.find_element(:xpath,"//frameset/frame[1]").displayed? == true}
    @driver.switch_to.frame("cma_menu")
    @wait.until{@driver.find_element(:css,".pub").displayed? == true}
    # Click on Add Product 
    content_type = @driver.find_element(:css,".pub")
    option = Selenium::WebDriver::Support::Select.new(content_type)
    option.select_by(:text,"PC Magazine")
    @wait.until{@driver.find_element(:xpath,"//a[contains(@href,'product.aspx')]").displayed? == true}
    @lib_obj.clickandwait(@driver.find_element(:xpath,"//a[contains(@href,'product.aspx')]"))
    @driver.switch_to.default_content
    @wait.until{@driver.find_element(:xpath,"//frameset/frame[2]").displayed? == true}
    @driver.switch_to.frame("cma_main")
    @driver.find_element(:css,"input[id*='_txtProductName']").send_keys(@product[@data]['Product_Name'])
    @lib_obj.clickandwait(@driver.find_element(:css,"input[id*='_ucxProductCategory_btnPopupButton']"))
    # @driver.find_element(:css,"input[id*='_ucxProductCategory_btnPopupButton']").click
    @driver.switch_to.default_content
    print @driver.window_handles
    @wait.until{@driver.window_handles.size == 2}
    if(@driver.window_handles.size == 2)
      @driver.switch_to.window(@driver.window_handles.last)
      @wait.until{@driver.find_elements(:tag_name,"frame").size == 3}
      @driver.switch_to.frame("middle_frame")
      @wait.until{@driver.find_element(:css,"input[id*='_ctlBody_idList']").displayed? == true}
      @driver.find_element(:css,"input[id*='_ctlBody_idList']").send_keys(@product[@data]['Product_Category_id'])
      @lib_obj.clickandwait(@driver.find_element(:css,"input[id*='ctlBody_btnSubmit']"))
      @driver.switch_to.default_content
      @driver.switch_to.frame("top")
      element = @driver.find_element(:css,"#ddListBox")
      @wait.until{element.find_element(:xpath,".//option").displayed? == true}
      element.find_element(:xpath,".//option").text.should == @product[@data]['Product_Category_name']
      @driver.find_element(:css,"img[name='btnReturn']").click
      @driver.switch_to.default_content
      @driver.switch_to.window(@driver.window_handles.first)
      @driver.switch_to.frame("cma_main")
      # Add Product image
      # @driver.find_element(:css,"input[id*='_ucxProductImage_txtSingleTextbox']").send_keys(@product[@data]['product_Image'])
      # Add Faucets
      @driver.find_element(:css,"img[id*='ucxManufacturer_imgPopupButton']").click
      @wait.until{@driver.window_handles.size == 2}
      if(@driver.window_handles.size == 2)
        @driver.switch_to.window(@driver.window_handles.last)
        @wait.until{@driver.find_element(:css,"input[id*='ctlBody_txtCompanyName']").displayed? == true}
        @driver.find_element(:css,"input[id*='ctlBody_txtCompanyName']").send_keys(@product[@data]['Manufacturer'])
        @driver.find_element(:css,"input[id*='_ctlBody_btnSearch']").click
        @wait.until{@driver.find_element(:css,"table[id*='ctlBody_dgResults']").displayed? == true}
        @driver.find_element(:css,"input[id*='ctl3_btnAdd']").click
        @driver.switch_to.default_content
        @driver.switch_to.window(@driver.window_handles.first)
        @driver.switch_to.frame("cma_main")
      end
      @driver.find_element(:css,"input[id*='ctlBody_btnSave']").click
      @wait.until{@driver.find_element(:css,"span[id*='_lblProductId']").displayed? == true}
      @product[@data]['product_id'] = @driver.find_element(:css,"span[id*='_lblProductId']").text
      File.open(File.dirname(__FILE__) + '/../../config/ProductData.yml','w') {|f| f.write @product.to_yaml }
      print @product[@data]['product_id']
      @driver.switch_to.default_content
    end
  end

  it "Add Article and save" do
    # article = $article
    # data = $data
    # print article
    random = Random.rand(10000)
    @driver.switch_to.frame("cma_menu")
    @driver.find_element(:css,"a[href*='article/add']").click
    @driver.switch_to.default_content
    @driver.switch_to.frame("cma_main")
    content_type = @driver.find_element(:name,"article_type_id")
    @lib_obj.selectDropdownOption(content_type,"Standard Review")
    @driver.find_element(:css,"input[type='button']").click
    @wait.until{@driver.find_element(:css,"input[name='title']").displayed? == true}
    @driver.find_element(:css,"input[name='title']").send_keys("Test_Article_title_#{random}")
    @article[@article_data]['Article_title'] = "Test_Article_title_#{random}"
    File.open(File.dirname(__FILE__) + '/../../config/ArticleData.yml','w') {|f| f.write @article.to_yaml }
    @driver.find_element(:css,"input[name='short_title']").send_keys("Test_Article_title_#{random}")
    primary_section = @driver.find_element(:css,"select[name='primary_section_id']")
    ad_choice = @driver.find_element(:css,"select[name='ad_topic_id']")
    @lib_obj.selectDropdownOption(primary_section,"#{@article[@article_data]['Primary_Archive_Section']}")
    @lib_obj.selectDropdownOption(ad_choice,"#{@article[@article_data]['Ad_Topic']}")
    @driver.find_element("css","textarea[name='body']").send_keys(@article[@article_data]['Body'])
    @lib_obj.selectImageArticle("css","input[name='filter_addbutton']","addImageFrame","#{@article[@article_data]['Filter_Image_id']}")
    @lib_obj.selectImageArticle("xpath","//input[contains(@onclick,'fnProductPopUp')]","addProductFrame","#{@product[@data]['product_id']}")
    @lib_obj.selectImageArticle("xpath","//input[contains(@name,'article_addbutton') and contains(@onclick,'fnImgPopUp')]","addImageFrame","#{@article[@article_data]['Primary_Image']}")
    @lib_obj.selectImageArticle("css","input[onclick*='fnSlideshowPopUp']","addProductFrame","#{@article[@article_data]['Slide_show']}")
    #Select Related Companies
    @driver.find_element(:css,"input[name='related_company_addbutton']").click
    if(@driver.window_handles.size == 2)
      @driver.switch_to.default_content
      @driver.switch_to.window(@driver.window_handles.last)
      @driver.switch_to.frame("searchFrame")
      @driver.find_element(:css,"input[name='company_name']").send_keys(@article[@article_data]['Related_Companies'])
      @lib_obj.clickandwait(@driver.find_element(:css,"input[name='submitted']"))
      @lib_obj.clickandwait(@driver.find_element(:css,"a[href*='javascript:void(0)']"))
      @driver.switch_to.default_content
      @driver.switch_to.frame("addCompanyFrame")
      @driver.find_element(:css,"input[name='done']").click
    end
    @driver.switch_to.window(@driver.window_handles.first)
    @driver.switch_to.default_content
    @driver.switch_to.frame("cma_main")
    @driver.find_element(:css,"input[name='meta_title']").send_keys("Test_Article_title_#{random}")
    @driver.find_element(:css,"textarea[name='meta_description']").send_keys("Meta Description")
    @driver.find_element(:css,"input[value='Save']").click
    sleep 1
    @driver.switch_to.alert.accept
    @wait.until{@driver.find_element(:xpath,"//td[contains(.,'ID')]/../td[2]").displayed? == true}
    @article[@article_data]['Article_id'] = @driver.find_element(:xpath,"//table/tbody/tr[1]/td[2]").text
    File.open(File.dirname(__FILE__) + '/../../config/ArticleData.yml','w') {|f| f.write @article.to_yaml }
    @wait.until{@driver.find_element(:xpath,"//table/tbody/tr[1]/td[2]").displayed? == true}
    @wait.until{@driver.find_element(:css,"input[value='Publish']").displayed? == true}
    sleep 5
    @driver.find_element(:css,"input[value='Publish']").click
    sleep 1
    @driver.switch_to.alert.accept
    sleep 60
    
    @wait.until{@driver.find_element(:css,"input[value='Unpublish']").displayed? == true}
  end
end
