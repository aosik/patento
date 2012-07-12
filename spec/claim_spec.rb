require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Claim do
	describe "attributes" do
	  it { should respond_to :number }	
		it { should respond_to :type }
		it { should respond_to :preamble }
		it { should respond_to :body }
	end
	
	describe "extracting a claim set" do
	  let(:claims) { Claim.extract_all(6000015, local_path: "#{$LOAD_PATH[0]}/data/US6000015.html")}
		subject { claims }
		
		it { should have(7).items}
	
	end
	
end

