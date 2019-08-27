require 'pwinty/photo_status'

module Pwinty

	class OrderStatus < Pwinty::Base
		attribute :id, Types::Coercible::Integer
		attribute :isValid, Types::Bool
		attribute :generalErrors, Types::Array.of(Types::String)
		attribute :photos, Types::Array.of(Pwinty::PhotoStatus)
		

		def self.check(id)
	      	response = Pwinty.conn.get("orders/#{id}/SubmissionStatus")
	      	new(response.body['data'])
	    end
	end
end
