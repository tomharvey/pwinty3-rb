RSpec.describe Pwinty::Order do
  it "has an Order class" do
    expect(Pwinty::Order).to be_truthy
  end

  it "can create an order" do
   VCR.use_cassette('order/create') do
    order = Pwinty::Order.create(
      recipientName: "FirstName LastName",
    countryCode: "US",
    preferredShippingMethod: "Budget"
    )
    expect(order).to be_kind_of(Pwinty::Order)
    expect(order.id).to be_truthy

    expect(order.recipientName).to eq('FirstName LastName')
    expect(order.countryCode).to eq('US')
    expect(order.preferredShippingMethod).to eq('Budget')
  end
 end

  it "can get an order" do
    VCR.use_cassette('order/get') do
      order = Pwinty::Order.find(794822)

      expect(order).to be_kind_of(Pwinty::Order)
      expect(order.id).to eq(794822)
      expect(order.recipientName).to eq('FirstName LastName')
      expect(order.countryCode).to eq('US')
      expect(order.preferredShippingMethod).to eq('Budget')
    end
  end

  it "can update an order" do
    VCR.use_cassette('order/update') do
      order = Pwinty::Order.create(
          recipientName: "FirstName LastName",
        countryCode: "US",
        preferredShippingMethod: "Budget"
        )

      order.update(
        address1: 'House number',
        address2: 'Street address'
      )

      expect(order.address1).to eq('House number')
      expect(order.address2).to eq('Street address')
      expect(order.recipientName).to eq('FirstName LastName')
      expect(order.countryCode).to eq('US')
      expect(order.preferredShippingMethod).to eq('Budget')
    end
  end

  it "can list orders" do
    VCR.use_cassette('order/list') do
      orders = Pwinty::Order.list

      expect(orders[0]).to be_kind_of(Pwinty::Order)
      expect(orders.count).to eq(Pwinty::Order.count)
    end
  end

  it "can count orders" do
    VCR.use_cassette('order/count') do
      count = Pwinty::Order.count
      expect(count).to be > 467
    end
  end

  it "can validate an order" do
    VCR.use_cassette('order/get') do
      @order = Pwinty::Order.find(794822)
    end

    VCR.use_cassette('order/status') do
      status = @order.submission_status

      expect(status).to be_kind_of(Pwinty::OrderStatus)
      expect(status.id).to eq(@order.id)
      expect(status.id).to eq(794822)
      expect(status.isValid).to be(false)
      expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
    end
  end

  it "can add an image to an order" do
    VCR.use_cassette('order/create') do
      @order = Pwinty::Order.create(
        recipientName: "FirstName LastName",
      countryCode: "US",
      preferredShippingMethod: "Budget"
      )
    end

    VCR.use_cassette('order/add_image') do
      @order.add_image(
        sku: "GLOBAL-PHO-4X6-PRO",
        url: "http://example.com/mytestphoto.jpg",
        copies: 1,
      )
    end

    expect(@order.images.count).to eq 1
    expect(@order.images[0].status).to eq "NotYetDownloaded"
    expect(@order.images[0].copies).to eq 1
  end

  it "can add an image to an order" do
    VCR.use_cassette('order/add_multi_images') do
     order = Pwinty::Order.create(
       recipientName: "FirstName LastName",
     countryCode: "US",
     preferredShippingMethod: "Budget"
     )
     expect(order.images.count).to eq 0
    
     order.add_images(
       [{
         sku: "GLOBAL-PHO-4X6-PRO",
         url: "http://example.com/myTestPhoto.jpg",
         copies: 1,
       }, {
         sku: "GLOBAL-PHO-10X12-PRO",
         url: "http://example.com/myLargeTestPhoto.jpg",
         copies: 1,
       }]
     )

     expect(order.images.count).to eq 2

     order.images.each do |order_image|
       expect(order_image.status).to eq "NotYetDownloaded"
       expect(order_image.copies).to eq 1
     end
   end
  end

  it "can attempt to add an image to an order that will result in a pwinty api error" do
    VCR.use_cassette('order/add_multi_images_which_will_api_error') do
     order = Pwinty::Order.create(
       recipientName: "FirstName LastName",
       countryCode: "US",
       preferredShippingMethod: "Budget"
     )
     expect(order.images.count).to eq 0

     order.add_images(
       [{
         sku: "GLOBAL-PHO-4X6-PRO",
         url: "myTestPhoto.jpg",
         copies: 1,
       }]
     )

     expect(order.images.count).to eq 0
   end
  end

  it "can build and submit a valid order" do
    VCR.use_cassette('order/end_to_end') do
      order = Pwinty::Order.create(
        recipientName: "Tom Harvey",
        address1: "My House",
        addressTownOrCity: "Glasgow",
        stateOrCounty: "Scotland",
        postalOrZipCode: "G1 3XX",
        countryCode: "GB",
        preferredShippingMethod: "Budget",	
    )

      order.add_image(
        sku: "GLOBAL-PHO-4X6-PRO",
          url: "https://github.com/tomharvey/pwinty3-rb/raw/master/spec/TestImage.jpg",
          copies: 1,
      )

      submitted = order.submit

      expect(submitted).to be true
    end
  end

  it "can get the shipment info from a submitted order" do
    VCR.use_cassette('order/submitted_shipment') do
      order = Pwinty::Order.find(795042)

      expect(order.shippingInfo.price).to eq 500
      expect(order.shippingInfo.shipments[0].trackingNumber).to eq 'XYZ123456ABC'
    end
  end

  it "cannot hold or cancel a submitted order" do
    VCR.use_cassette('order/hold_cancel_fail') do
      order = Pwinty::Order.find(795042)

      cancelled = order.cancel
      expect(cancelled).to be false

      held = order.hold
      expect(held).to be false
    end
  end

  it "can cancel an unsubmitted order" do
    VCR.use_cassette('order/cancel_success') do
      order = Pwinty::Order.find(795145)

      cancelled = order.cancel
      expect(cancelled).to be true
    end
  end

end
