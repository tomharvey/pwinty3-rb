require 'json'

module Pwinty3

	class OrderStatus
		attr_reader :id, :isValid, :generalErrors
		def initialize(attributes)
			@id = attributes['id'].to_i  # This endpoint returns ID as a string. Convert for consistency
			@isValid = attributes['isValid']
			@generalErrors = attributes['generalErrors']
		end

		def self.check(id)
	      	response = Pwinty3.conn.get("orders/#{id}/SubmissionStatus")
	      	attributes = JSON.parse(response.body)
	      	new(attributes['data'])
	    end
	end
end