module Pwinty
  class OrderPackingSlip < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-packing-slip"""
    attribute? :url, Types::String.optional
    attribute? :status, Types::String.optional
  end
end
