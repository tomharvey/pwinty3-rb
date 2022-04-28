module Pwinty
  class OrderItem < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-item"""
    attribute? :id, Types::String.optional
    attribute? :merchantReference, Types::String.optional
    attribute? :sku, Types::String
    attribute? :copies, Types::Integer
    attribute? :sizing, Types::String.default('fillPrintArea')
    attribute? :assets, Types::Array.of(Pwinty::OrderAsset)
    attribute? :attributes, Types::Hash

    def serializable
      item_attrs = Hash.new
      item_attrs.update(self.attributes)
      item_attrs[:assets] = []
      for asset in self.assets
        item_attrs[:assets] << asset.attributes 
      end
      item_attrs
    end

  end

end
