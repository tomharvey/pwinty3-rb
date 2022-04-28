require "pwinty/api_models/order_status_details"
require "pwinty/api_models/order_status_issue"

module Pwinty
  class OrderStatus < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#status-status-object"""
    attribute? :stage, Types::String.default('NotYetSubmitted')
    attribute? :details, Pwinty::OrderStatusDetails
    attribute? :issues, Types::Array.of(Pwinty::OrderStatusIssue)
  end
end
