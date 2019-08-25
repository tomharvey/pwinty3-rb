require 'json'

module Pwinty3

	class Country < Pwinty3::Base
		attribute :name, Types::String
		attribute :isoCode, Types::String

		def self.list
			response = Pwinty3.conn.get("countries")
			attributes = JSON.parse(response.body)
			countries_data = attributes['data']

			countries = []
			countries_data.each do |attr|
				countries << new(attr)
			end
			countries
		end
	end
end
