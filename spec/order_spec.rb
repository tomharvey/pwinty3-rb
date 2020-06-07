RSpec.describe Pwinty::Order do
  it "has an Order class" do
    expect(Pwinty::Order).to be_truthy
  end

  it "can create an order" do
    VCR.use_cassette('order/create') do
      order = create_order
      expect(order).to be_kind_of(Pwinty::Order)
      expect(order.id).to be_truthy

      expect(order.recipientName).to eq('FirstName LastName')
      expect(order.countryCode).to eq('US')
      expect(order.preferredShippingMethod).to eq('Budget')
    end
  end

  it "can get an order" do
    VCR.use_cassette('order/finding_an_order') do
      created_order = create_order
      order = Pwinty::Order.find(created_order.id)
      expect(order).to be_kind_of(Pwinty::Order)
      expect(order.id).to eq(created_order.id)
      expect(order.recipientName).to eq('FirstName LastName')
      expect(order.countryCode).to eq('US')
      expect(order.preferredShippingMethod).to eq('Budget')
    end
  end

  it "can update an order" do
    VCR.use_cassette('order/update') do
      order = create_order

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

  context "updating the attributes in a model" do

    before :each do
      VCR.use_cassette('order/updating_model_attributes--setup') do
        @order = create_order
      end
    end

    it "can update the attributes in a model" do
      VCR.use_cassette('order/updating_model_attributes--model-attr-update') do
        @order.update_instance_attributes(addressTownOrCity: 'Valencia')
      end
      expect(@order.addressTownOrCity).to eq('Valencia')
    end

    it "can update the omittable attributes in a model" do
      VCR.use_cassette('order/updating_model_attributes--model-omittable-attr-update') do
        @order.update_instance_attributes(packingSlipUrl: 'https://example.com/slip.jpg')
      end
      expect(@order.packingSlipUrl).to eq('https://example.com/slip.jpg')
    end

  end

  it "can list orders" do
    VCR.use_cassette('order/list') do
      order = create_order
      orders = Pwinty::Order.list

      expect(orders[0]).to be_kind_of(Pwinty::Order)
      expect(orders.count).to eq(Pwinty::Order.count)
    end
  end

  it "can count orders" do
    VCR.use_cassette('order/count') do
      count = Pwinty::Order.count
      expect(count).to be_an(Numeric)
    end
  end

  it "can validate an order" do
    VCR.use_cassette('order/status') do
      order = create_order
      status = order.submission_status

      expect(status).to be_kind_of(Pwinty::OrderStatus)
      expect(status.id).to eq(order.id)
      expect(status.isValid).to be(false)
      expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
    end
  end

  it "can add an image to an order" do
    VCR.use_cassette('order/add_image') do
      @order = create_order
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
      order = create_order
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
      order = create_order
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
    VCR.use_cassette('order/submitted_order--shipping_info') do
      order = submitted_order
      expect(order.shippingInfo).to be_an(Pwinty::ShippingInfo)

      shipment = order.shippingInfo.shipments[0]
      expect(shipment).to be_an(Pwinty::Shipment)
    end
  end

  it "cannot hold a submitted order" do
    VCR.use_cassette('order/submitted_order--hold_fail') do
      order = submitted_order

      expect(order.canHold).to be(false)
      held = order.hold
      expect(held).to be false
    end
  end

  it "can cancel a submitted order " do
    VCR.use_cassette('order/submitted_order--cancel_success') do
      order = submitted_order

      expect(order.canCancel).to be(true)
      cancelled = order.cancel
      expect(cancelled).to be true
    end
  end

end
