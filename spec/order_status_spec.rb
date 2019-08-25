RSpec.describe Pwinty3::OrderStatus do
	it "has an OrderStatus class" do
		expect(Pwinty3::OrderStatus).to be_truthy
	end

  	it "can check an order's status" do
	  	VCR.use_cassette('order_status/check') do
	  		status = Pwinty3::OrderStatus.check(794822)

	  		expect(status).to be_kind_of(Pwinty3::OrderStatus)
	  		expect(status.id).to eq(794822)
	  		expect(status.isValid).to be(false)
	  		expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
	  	end
  	end

end
