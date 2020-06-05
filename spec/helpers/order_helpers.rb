module Helpers
  module OrderHelpers

    def create_order
      Pwinty::Order.create(
        recipientName: "FirstName LastName",
        countryCode: "US",
        preferredShippingMethod: "Budget"
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