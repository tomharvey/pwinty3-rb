module Pwinty
  class OrderStatusAuthDetails < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#status-status-authorisation-details"""
    attribute? :authorisationUrl, Types::String.optional
    attribute? :paymentDetails, Pwinty::OrderCost
  end
end
