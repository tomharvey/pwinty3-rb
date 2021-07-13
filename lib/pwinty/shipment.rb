module Pwinty

  class Shipment < Pwinty::Base
    attribute :shipmentId, Types::String.optional
    attribute :isTracked, Types::Bool
    attribute :trackingNumber, Types::String.optional
    attribute :trackingUrl, Types::String.optional
    attribute :carrier, Types::String.optional
    attribute :photoIds, Types::Array.of(Types::Integer)
    attribute :earliestEstimatedArrivalDate, Types::JSON::DateTime.optional
    attribute :latestEstimatedArrivalDate, Types::JSON::DateTime.optional
    attribute :shippedOn, Types::JSON::DateTime.optional
  end
end
