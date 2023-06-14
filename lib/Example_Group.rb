require 'rake'
require 'selenium-webdriver'
require 'Function_Library'
require 'rspec'

share_examples_for "Check Tags" do |id_path,description|
  it "#{description}" "- tag-siteName" do
    @lib_obj.check_attribute_adtag("#{id_path}","siteName").should == true
  end

  it "#{description}" "- tag-zoneName" do
    @lib_obj.check_attribute_adtag("#{id_path}", "zoneName").should == true  
  end

  it "#{description}" "- tag-zdaudience" do
    if(@lib_obj.check_attribute_adtag("#{id_path}", "zdaudience") == true)
      @lib_obj.check_attribute_adtag("#{id_path}", "zdaudience").should == true  
    else
      pending("tag-zdaudience is pending") do
        this_should_not_get_executed 
      end
    end  
  end

  it "#{description}" " - tag-sz" do
    @lib_obj.check_attribute_adtag("#{id_path}", "sz").should == true  
  end

  it "#{description}" " - tag-zdtopic" do
    @lib_obj.check_attribute_adtag("#{id_path}", "zdtopic").should == true  
  end

  it "#{description}" "- tag-tile" do
    if(@lib_obj.check_attribute_adtag("#{id_path}", "tile") == true)
      @lib_obj.check_attribute_adtag("#{id_path}", "tile").should == true  
    else
      pending("tag-tile is pending") do
        this_should_not_get_executed 
      end  
    end  
  end

  it "#{description}"" - tag-ref" do
    if(@lib_obj.check_attribute_adtag("#{id_path}", "ref") == true)
      @lib_obj.check_attribute_adtag("#{id_path}", "ref").should == true  
    else
      pending("tag-ref is pending") do
        this_should_not_get_executed 
      end 
    end
  end

  it "#{description}" "- tag-cmn" do
    @lib_obj.check_attribute_adtag("#{id_path}", "cmn").should == true  
  end
  
  it "#{description}" "- tag-ord" do
    @lib_obj.check_attribute_adtag("#{id_path}", "ord").should == true  
  end
end # Example ends