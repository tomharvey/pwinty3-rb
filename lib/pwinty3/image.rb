require 'json'

module Pwinty3

	class Image < Pwinty3::Base
		attribute :id, Types::Integer
		attribute :url, Types::String
		attribute :status, Types::String
		attribute :copies, Types::Integer
		attribute :sizing, Types::String
		attribute :price, Types::Integer
		attribute :priceToUser, Types::Integer
		attribute :md5Hash, Types::String
		attribute :previewUrl, Types::String
		attribute :thumbnailUrl, Types::String
		attribute :sku, Types::String
		attribute :attributes, Types::Hash
		attribute :errorMessage, Types::String
	end
end
