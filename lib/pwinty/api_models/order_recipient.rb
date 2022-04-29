require "pwinty/api_models/order_recipient_address"

module Pwinty
  class OrderRecipient < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-recipient"""
    attribute? :name, Types::String.optional
    attribute? :email, Types::String.optional
    attribute? :phoneNumber, Types::String.optional
    attribute? :address, Pwinty::OrderRecipientAddress

    def serializable
      recp_attrs = self.attributes
      recp_attrs[:address] = self.address.attributes
      recp_attrs
    end
  end
end
