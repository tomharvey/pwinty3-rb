require "pwinty/api_models/order_shipment_carrier"
require "pwinty/api_models/order_shipment_item"
require "pwinty/api_models/order_shipment_fulfillment_location"
require "pwinty/api_models/order_tracking"

module Pwinty
  class OrderShipment < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-shipment"""
    attribute? :id, Types::String.optional
    attribute? :carrier, Pwinty::OrderShipmentCarrier.optional
    attribute? :tracking, Pwinty::OrderTracking.optional
    attribute? :dispatchDate, Types::String.optional
    attribute? :items, Types::Array.of(Pwinty::OrderShipmentItem).optional
    attribute? :fulfillmentLocation, Pwinty::OrderShipmentFulfillmentLocation
  end
end
