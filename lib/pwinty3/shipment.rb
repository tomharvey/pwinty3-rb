require 'json'

module Pwinty3

	class Shipment
		attr_reader :shipmentId, :isTracked, :trackingNumber, :trackingUrl, :earliestEstimatedArrivalDate, :latestEstimatedArrivalDate, :shippedOn, :carrier, :photoIds
		def initialize(attributes)
			@shipmentId = attributes['shipmentId']
			@isTracked = attributes['isTracked']
			@trackingNumber = attributes['trackingNumber']
			@trackingUrl = attributes['trackingUrl']
			@earliestEstimatedArrivalDate = attributes['earliestEstimatedArrivalDate']
			@latestEstimatedArrivalDate = attributes['latestEstimatedArrivalDate']
			@shippedOn = attributes['shippedOn']
			@carrier = attributes['carrier']
			@photoIds = attributes['photoIds']
		end
	end
end