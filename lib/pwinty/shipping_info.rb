require "pwinty/shipment"

module Pwinty

	class ShippingInfo < Pwinty::Base
		attribute :price, Types::Integer
		attribute :shipments, Types::Array.of(Pwinty::Shipment)
	end
end
