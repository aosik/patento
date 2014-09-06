require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Patent do
  
  describe "patent number 7,114,060" do
    before { Patento.stub(:download_html).and_return(File.read("#{$LOAD_PATH[0]}/data/US7114060.html"))}
    let(:patent) { Patent.new(7114060) }
    subject { patent }
    
    describe "attributes" do
      it { should respond_to :serial }
    end
    
    describe "parsing" do
      its(:serial) { should == '10686061' }
    end
    
  end
  
  describe "patent number 6,000,000" do
    before { Patento.stub(:download_html).and_return(File.read("#{$LOAD_PATH[0]}/data/US6000000.html"))}
    let(:patent) { Patent.new(6000000) }
    subject { patent }

    describe "attributes" do
      it { should respond_to(:number) }
      it { should respond_to(:title) }
      it { should respond_to(:abstract) }
      it { should respond_to(:inventors) }
      it { should respond_to(:assignee) }
      it { should respond_to(:serial) }
      it { should respond_to(:us_classifications) }
      it { should respond_to(:intl_classification) }
      it { should respond_to(:filing_date) }
      it { should respond_to(:issue_date) }
      it { should respond_to(:claims) }
    end


    describe 'downloading' do

      context "from Google", :slow => true do
        xit "should download a patent from the Internets" do
          remote_html = Nokogiri::HTML(Downloader.download_html(6000000))
        end
      end

      context "from local file" do
        let(:patent) { Patent.new(6000000, local_path: "#{$LOAD_PATH[0]}/data/US6000000.html")}
        its(:html) { should be_an_instance_of Nokogiri::HTML::Document}
      end

    end

    describe 'parsing U.S. Patent No. 6,000,000' do

      its(:number) { should == '6000000'}

      describe "general information" do
        its(:title) { should == 'Extendible method and apparatus for synchronizing multiple files on two different computer systems'}
        its(:abstract) { should == 'Many users of handheld computer systems maintain databases on the handheld computer systems. To share the information, it is desirable to have a simple method of sharing the information with personal computer systems. An easy to use extendible file synchronization system is introduced for sharing information between a handheld computer system and a personal computer system. The synchronization system is activated by a single button press. The synchronization system proceeds to synchronize data for several different applications that run on the handheld computer system and the personal computer system. If the user gets a new application for the handheld computer system and the personal computer system, then a new library of code is added for synchronizing the databases associate with the new application. The synchronization system automatically recognizes the new library of code and uses it during the next synchronization.'}
        its(:inventors) { should include('Jeffrey C. Hawkins', 'Michael Albanese')}
        its(:assignee) { should == '3Com Corporation'}
        its(:us_classifications) { should include('707/610', '707/758', '707/822', '707/922', '707/999.201', '714/E11.128', '714/E11.129')}
        its(:intl_classification) { should == 'G06F 1730' }
        its(:filing_date) { should == Date.parse('May 4, 1998')}
        its(:issue_date)  { should == Date.parse('Dec 7, 1999')}
        its(:serial) { should == nil }
      end

      describe "claims" do

        its(:claims) { should have(27).items}

        describe "claim 1" do

          it "should have a preamble" do
            patent.claims.first.preamble.should == 'A method of sharing information on a first computer system and a second computer system, said method comprising:'
          end

          it "should have body elements" do
            patent.claims.first.body.count.should == 5
          end

          it "should have text for the body elements" do
            patent.claims.first.body[0].should == 'connecting said first computer system to said second computer system with a data communications link;'
            patent.claims.first.body[1].should == 'providing a library of functions in said second computer system for accessing information on said first computer system;'
            patent.claims.first.body[2].should == 'creating a conduit program database, said conduit program database for storing a list of conduit programs that may be executed,'
            patent.claims.first.body[3].should == 'registering a first conduit program by placing an identifier for said first conduit program in said conduit program database, said first conduit program comprising a computer program on said second computer system for performing a specific data transfer task;'
            patent.claims.first.body[4].should == 'successively executing a set of conduit programs identified within said conduit program database from a manager program, each of said conduit programs accessing said library of functions for communicating with said first computer system.'
          end

        end

        describe "claim 2" do
          it "should have a preamble" do
            patent.claims[1].preamble.should == 'The method of sharing information as claimed in claim 1 further comprising:'
          end
          it "should have body elements" do
            patent.claims[1].body.count.should == 1
          end

          it "should have text for the body element" do
            patent.claims[1].body[0].should == 'registering a second conduit program by placing an identifier for said second conduit program in said conduit program database, said second conduit program comprising a computer program on said second computer system for performing a specific data transfer task.'
          end
        end

      end

      describe "backward citations" do

        describe "list" do
          its(:backward_citations) { should be_an_instance_of Array }
          its(:backward_citations) { should have(57).items}
        end

        describe "individual citation" do
          let(:citation) { patent.backward_citations.first}
          subject { citation }
          it { should be_an_instance_of Hash }
          it "should have a number" do
            citation[:number].should == '4432057'
          end
          it "should have a filing date" do
            citation[:filing].should == Date.parse('Nov 27, 1981')
          end
          it "should have an issue date" do
            citation[:issue].should == Date.parse('Feb 14, 1984')
          end
          it "should have an assignee" do
            citation[:assignee].should == 'International Business Machines Corporation'
          end
          it "should have a title" do
            citation[:title].should == 'Method for the dynamic replication of data under distributed system control to control utilization of resources in a multiprocessing, distributed data base system'
          end
        end

      end



      describe "forward citations" do

        describe "list" do
          its(:forward_citations) { should be_an_instance_of Array }
          its(:forward_citations) { should have(252).items}
        end

        describe "individual citation" do
          let(:citation) { patent.forward_citations.first}
          subject { citation }
          it { should be_an_instance_of Hash }
          it "should have a number" do
            citation[:number].should == '6098100'
          end
          it "should have a filing date" do
            citation[:filing].should == Date.parse('Jun 8, 1998')
          end
          it "should have an issue date" do
            citation[:issue].should == Date.parse('Aug 1, 2000')
          end
          it "should have an assignee" do
            citation[:assignee].should == 'Silicon Integrated Systems Corp.'
          end
          it "should have a title" do
            citation[:title].should == 'Method and apparatus for detecting a wake packet issued by a network device to a sleeping node'
          end
        end

      end

    end

    describe "parsing a patent with multi-level claims" do
      let(:patent) { Patent.new(6000015, local_path: "#{$LOAD_PATH[0]}/data/US6000015.html")}

      it "should have a preamble for claim 1" do
        patent.claims.first.preamble.should == 'In a digital network connected by a system bus means having a snoop logic module to retrieve addresses being modified, a central processor and processor bus having a multi-level cache system which reduces traffic on the processor bus of a central processor and allows different cache fill algorithms for a first and second level cache memory, said multi-level cache system comprising:'
      end

      it "should have a nested body" do
        patent.claims.first.body.count.should == 4
      end

    end
  end
  
end
