require 'combo_helper'
PUT=3000
CALL=3200
RSpec.describe "IB::Strangle" do
	let ( :the_option ){ IB::Option.new  symbol: :Estx50, strike: PUT, right: :put, expiry: IB::Symbols::Futures.next_expiry }
  before(:all) do
    verify_account
    IB::Connection.new OPTS[:connection].merge(:logger => mock_logger) do |gw|
			gw.subscribe( :Alert ){|y|  puts y.to_human }
		end
  end

  after(:all) do
    close_connection
  end

	context "fabricate with master-option" do
		subject { IB::Strangle.fabricate the_option, 200 }
		it{ is_expected.to be_a IB::Bag }
		it_behaves_like 'a valid Estx Combo'
		
			
	end

	context "build with underlying" do
		subject{ IB::Strangle.build from: IB::Symbols::Index.stoxx, p: PUT, c: CALL }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end
	context "build with option"  do
		subject{ IB::Strangle.build from: the_option, c: CALL }

		it{ is_expected.to be_a IB::Spread }
		it_behaves_like 'a valid Estx Combo'
	end

			

end
