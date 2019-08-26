require 'json'

module Pwinty3

	class Country < Pwinty3::Base
		attribute :name, Types::String
		attribute :isoCode, Types::String

		def self.list
			response = Pwinty3.conn.get("countries")
			countries = collate_results(response.body['data'])
			countries
		end

		protected

		def collate_results countries_data
			countries = []
			countries_data.each do |attr|
				countries << new(attr)
			end
			countries
		end
	end
end
