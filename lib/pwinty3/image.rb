module Pwinty3

	class Image < Pwinty3::Base
		attribute :id, Types::Integer
		attribute :url, Types::String
		attribute :status, Types::String
		attribute :copies, Types::Integer
		attribute :sizing, Types::String
		attribute :price, Types::Integer
		attribute :priceToUser, Types::Integer.optional
		attribute :md5Hash, Types::String.optional
		attribute :previewUrl, Types::String.optional
		attribute :thumbnailUrl, Types::String.optional
		attribute :sku, Types::String
		attribute :attributes, Types::Hash.schema(
			substrateWeight: Types::String,
			frame: Types::String,
			edge: Types::String,
			paperType: Types::String,
			frameColour: Types::String,
		).optional
		attribute :errorMessage, Types::String.optional
	end
end
