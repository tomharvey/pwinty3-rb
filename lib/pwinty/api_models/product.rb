require "pwinty/api_models/product_dimensions"
require "pwinty/api_models/product_variant"

module Pwinty
  class Product < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#product-details"""
    attribute :sku, Types::String
    attribute :description, Types::String
    attribute :productDimensions, Pwinty::ProductDimensions
    attribute :attributes, Types::Hash
    attribute :printAreas, Types::Hash
    attribute :variants, Types::Array.of(Pwinty::ProductVariant)

    def self.find(sku)
      response = Pwinty.conn.get("products/#{sku}")
      new(response.body['product'])
    end
  end
end
