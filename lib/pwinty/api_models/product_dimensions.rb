module Pwinty
  class ProductDimensions < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#product-details-object"""
    attribute :width, Types::Float
    attribute :height, Types::Float
    attribute :units, Types::String
  end
end
