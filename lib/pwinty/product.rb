module Pwinty

  class ProductDimensions < Pwinty::Base
    attribute :width, Types::Float
    attribute :height, Types::Float
    attribute :units, Types::String
  end

  class Product < Pwinty::Base
    attribute :sku, Types::String
    attribute :description, Types::String
    attribute :productDimensions, Pwinty::ProductDimensions

    def self.find(sku)
      response = Pwinty.conn.get("products/#{sku}")
      new(response.body['product'])
    end

  end

end