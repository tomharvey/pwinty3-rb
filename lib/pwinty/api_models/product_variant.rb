module Pwinty
  class ProductVariant < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#product-details-object-variant"""
    attribute :attributes, Types::Hash
    attribute :shipsTo, Types::Array.of(Types::String)
    attribute :printAreaSizes, Types::Hash
  end
end
