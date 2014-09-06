require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Publication do
  
  before { Patento.stub(:download_html).and_return(File.read("#{$LOAD_PATH[0]}/data/US20100268739.html"))}

  let(:publication) { Publication.new(20100268739) }

  subject { publication }

  it { should respond_to(:number) }
  it { should respond_to(:title) }
  it { should respond_to(:abstract) }
  it { should respond_to(:inventors) }
  it { should respond_to(:assignee) }
  it { should respond_to(:us_classifications) }
  it { should respond_to(:filing_date) }
  it { should respond_to(:claims) }


end
