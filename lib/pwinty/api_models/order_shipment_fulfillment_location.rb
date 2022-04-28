module Pwinty
  class OrderShipmentFulfillmentLocation < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-fulfillment-location"""
    attribute? :countryCode, Types::String.optional
    attribute? :labCode, Types::String.optional
  end
end
