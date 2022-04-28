module Pwinty
  class OrderCost < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-cost"""
    attribute? :amount, Types::String.optional
    attribute? :currency, Types::String.optional
  end
end
