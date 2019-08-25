require 'json'

require 'pwinty3/photo_status'

module Pwinty3

	class OrderStatus < Pwinty3::Base
		attribute :id, Types::Coercible::Integer
		attribute :isValid, Types::Bool
		attribute :generalErrors, Types::Array.of(Types::String)
		attribute :photos, Types::Array.of(Pwinty3::PhotoStatus)
		

		def self.check(id)
	      	response = Pwinty3.conn.get("orders/#{id}/SubmissionStatus")
	      	attributes = JSON.parse(response.body)
	      	new(attributes['data'])
	    end
	end
end
