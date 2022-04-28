require "pwinty/api_models/order_status_auth_details"

module Pwinty
  class OrderStatusIssue < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#status-status-object-issues"""
    attribute? :objectId, Types::String.optional
    attribute? :errorCode, Types::String.optional
    attribute? :description, Types::String.optional
    attribute? :authorisationDetails, Pwinty::OrderStatusAuthDetails.optional
  end
end
