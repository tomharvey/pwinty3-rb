require 'json'

module Pwinty3

	class Image
		attr_reader :id, url:, :status, :copies, :sizing, :price, :priceToUser, :md5Hash, :previewUrl, :thumbnailUrl, :sku, :attributes
		def initialize(attributes)
			@id = attributes['id']
			@url = attributes['url']
			@status = attributes['status']
			@copies = attributes['copies']
			@sizing = attributes['sizing']
			@price = attributes['price']
			@priceToUser = attributes['priceToUser']
			@md5Hash = attributes['md5Hash']
			@previewUrl = attributes['previewUrl']
			@thumbnailUrl = attributes['thumbnailUrl']
			@sku = attributes['sku']
			@attributes = attributes['attributes']
			@errorMessage = attributes['errorMessage']
		end
	end
end
