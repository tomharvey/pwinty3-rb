module Pwinty
  class OrderAsset < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-asset"""
    attribute? :printArea, Types::String.default('default')
    attribute? :url, Types::String
  end
end
