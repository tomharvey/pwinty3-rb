require 'json'

module Pwinty3

	class Country < Pwinty3::Base
		attribute :name, Types::String
		attribute :isoCode, Types::String

		def self.list
			response = Pwinty3.conn.get("countries")
			Pwinty3.collate_results(response.body['data'], self)
		end
	end
end
