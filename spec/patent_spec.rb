require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Patent do
  
  
  
  describe 'downloading', :slow => true do
    xit "should download a patent from the Internets" do
      remote_html = Nokogiri::HTML(Patent.download_html(6000000))
    end
  end
  
  describe 'downloading U.S. Patent No. 6,000,000' do
    
    before { Patent.stub(:download_html).and_return(File.read($LOAD_PATH[0] + '/data/US6000000.html'))}
    let(:patent) { Patent.new(6000000) }
    subject { patent }
    
    its(:number) { should == '6000000'}
    its(:title) { should == 'Extendible method and apparatus for synchronizing multiple files on two different computer systems'}
    its(:abstract) { should == 'Many users of handheld computer systems maintain databases on the handheld computer systems. To share the information, it is desirable to have a simple method of sharing the information with personal computer systems. An easy to use extendible file synchronization system is introduced for sharing information between a handheld computer system and a personal computer system. The synchronization system is activated by a single button press. The synchronization system proceeds to synchronize data for several different applications that run on the handheld computer system and the personal computer system. If the user gets a new application for the handheld computer system and the personal computer system, then a new library of code is added for synchronizing the databases associate with the new application. The synchronization system automatically recognizes the new library of code and uses it during the next synchronization.'}
    
    its(:inventors) { should include('Jeffrey C. Hawkins', 'Michael Albanese')}
    its(:assignee) { should == '3Com Corporation'}
    its(:us_classifications) { should include('707/610', '707/758', '707/822', '707/922', '707/999.201', '714/E11.128', '714/E11.129')}

    # its(:intl_classifications) { should include('G06F 1730') }
    
  end
  
  
end
