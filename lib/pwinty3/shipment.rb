module Pwinty3

	class Shipment < Pwinty3::Base
		attribute :shipmentId, Types::String
		attribute :isTracked, Types::Bool
		attribute :trackingNumber, Types::String
		attribute :trackingUrl, Types::String
		attribute :carrier, Types::String
		attribute :photoIds, Types::Array.of(Types::Integer)
		attribute :earliestEstimatedArrivalDate, Types::JSON::DateTime
		attribute :latestEstimatedArrivalDate, Types::JSON::DateTime
		attribute :shippedOn, Types::JSON::DateTime
	end
end
