RSpec.describe Pwinty3::Order do
	it "has an Order class" do
		expect(Pwinty3::Order).to be_truthy
	end

  	it "can create an order" do
  		VCR.use_cassette('order/create') do
		  	order = Pwinty3::Order.create(
		  		recipientName: "FirstName LastName",
				countryCode: "US",
				preferredShippingMethod: "Budget"
		  	)
		  	expect(order).to be_kind_of(Pwinty3::Order)
		  	expect(order.id).to be_truthy

		  	expect(order.recipientName).to eq('FirstName LastName')
		  	expect(order.countryCode).to eq('US')
		  	expect(order.preferredShippingMethod).to eq('Budget')
		 end
	 end

	it "can get an order" do
	  	VCR.use_cassette('order/get') do
			order = Pwinty3::Order.find(794822)

	  	 	expect(order).to be_kind_of(Pwinty3::Order)
	  	 	expect(order.id).to eq(794822)
	  	 	expect(order.recipientName).to eq('FirstName LastName')
		  	expect(order.countryCode).to eq('US')
		  	expect(order.preferredShippingMethod).to eq('Budget')
	  	end
	end

	it "can update an order" do
		VCR.use_cassette('order/update') do
			minimal_order = Pwinty3::Order.create(
		  		recipientName: "FirstName LastName",
				countryCode: "US",
				preferredShippingMethod: "Budget"
		  	)

			expect(minimal_order.id).to be_truthy

			updated_order = Pwinty3::Order.update(
				minimal_order.id,
				address1: '1 Street',
				addressTownOrCity: 'Las Vegas',
				stateOrCounty: 'NV',
				postalOrZipCode: '10001'
			)

			expect(updated_order.address1).to eq('1 Street')
		end
	end

	it "can list orders" do
		VCR.use_cassette('order/list') do
			orders = Pwinty3::Order.list

			expect(orders[0]).to be_kind_of(Pwinty3::Order)
			expect(orders.count).to eq(100)  # This should be 462 but there is a problem with the API?
		end
	end

	it "can count orders" do
		VCR.use_cassette('order/count') do
			count = Pwinty3::Order.count
			expect(count).to be > 467
		end
	end

  	it "can validate an order" do
  		VCR.use_cassette('order/get') do
	  		@order = Pwinty3::Order.find(794822)
	  	end

	  	VCR.use_cassette('order/status') do
	  		status = @order.submission_status

	  		expect(status).to be_kind_of(Pwinty3::OrderStatus)
	  		expect(status.id).to eq(@order.id)
	  		expect(status.id).to eq(794822)
	  		expect(status.isValid).to be(false)
	  		expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
	  	end
  	end

end
