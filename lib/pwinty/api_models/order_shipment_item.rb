module Pwinty
  class OrderShipmentItem < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-shipment-item"""
    attribute? :id, Types::String.optional
  end
end
