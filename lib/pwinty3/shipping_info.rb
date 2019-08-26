require "pwinty3/shipment"

module Pwinty3

	class ShippingInfo < Pwinty3::Base
		attribute :price, Types::Integer
		attribute :shipments, Types::Array.of(Pwinty3::Shipment)
	end
end
