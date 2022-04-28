module Helpers
  module OrderHelpers
  
    def stub_order_recipient_address
      Pwinty::OrderRecipientAddress.new(
        line1: '1 Main Street',
        postalOrZipCode: '90210',
        countryCode: 'US',
        townOrCity: 'Holywood',
      )
    end

    def stub_order_recipient
      Pwinty::OrderRecipient.new(
        name: 'Testy McTestface',
        address: stub_order_recipient_address,
      )
    end

    def stub_order_item_asset
      Pwinty::OrderAsset.new(
        url: 'https://example.com/image.jpg',
      )
    end

    def stub_order_item
      Pwinty::OrderItem.new(
        sku: 'GLOBAL-PHO-4X6-PRO',
        copies: 1,
        attributes: {finish: 'lustre'},
        assets: [stub_order_item_asset]
      )
    end

    def stub_order
      Pwinty::Order.new(
        shippingMethod: "Budget",
        recipient: stub_order_recipient,
        items: [stub_order_item],
      )
    end

    def submitted_order
      order = Pwinty::Order.create(
        recipientName: "Tom Harvey",
        address1: "My House",
        addressTownOrCity: "Glasgow",
        stateOrCounty: "Scotland",
        postalOrZipCode: "G1 3XX",
        countryCode: "GB",
        preferredShippingMethod: "Budget"
      )

      order.add_image(
        sku: "GLOBAL-PHO-4X6-PRO",
        url: "https://github.com/tomharvey/pwinty3-rb/raw/master/spec/TestImage.jpg",
        copies: 1,
      )
      order.submit

      # return the reloaded order
      Pwinty::Order.find(order.id)
    end

  end
end