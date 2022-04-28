require 'dry/struct/with_setters'

require "pwinty/api_models/order_asset"
require "pwinty/api_models/order_charge"
require "pwinty/api_models/order_cost"
require "pwinty/api_models/order_item"
require "pwinty/api_models/order_packing_slip"
require "pwinty/api_models/order_recipient"
require "pwinty/api_models/order_shipment"
require "pwinty/api_models/order_status"

module Pwinty

  DEFAULT_PAGE_SIZE = 10

  class Order < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object"""
    attribute? :id, Types::String.optional
    attribute? :created, Types::String.optional
    attribute? :callbackUrl, Types::String.optional
    attribute? :merchantReference, Types::String.optional
    attribute? :shippingMethod, Types::String.optional
    attribute? :idempotencyKey, Types::String.optional
    attribute? :status, Pwinty::OrderStatus.optional
    attribute? :charges, Types::Array.of(Pwinty::OrderCharge).optional
    attribute? :shipments, Types::Array.of(Pwinty::OrderShipment).optional
    attribute? :recipient, Pwinty::OrderRecipient.default(Pwinty::OrderRecipient.new)
    attribute? :items, Types::Array.of(Pwinty::OrderItem).default([])
    attribute? :packingSlip, Pwinty::OrderPackingSlip.optional
    attribute? :metadata, Types::Hash.optional

    def self.find(id)
      response = Pwinty.conn.get("orders/#{id}")
      new(response.body['order'])
    end

    def self.list(page_size: DEFAULT_PAGE_SIZE, limit: 0)
      """ Get all of the orders - this can take a while!

      Page size maximum is 100.
      Limit of 0 will get all of them.
      """
      all_orders = list_each_page(page_size: page_size, limit: limit)
      Pwinty.collate_results(all_orders, self)
    end

    def self.list_each_page(page_size: DEFAULT_PAGE_SIZE, limit: 0)
      all_orders = []
      page_start = 0
      has_more = true
      limit_reached = false
      while has_more and not limit_reached
        response = Pwinty.conn.get("orders?top=#{page_size}&skip=#{page_start}")
        all_orders = all_orders + response.body['orders']
        page_start += page_size
        limit_reached = Pwinty::is_limit_reached(all_orders.count, limit: limit)
        has_more = response.body['hasMore']
      end
      all_orders
    end

    def add_image image
      self.items << Pwinty::OrderItem.new(
        sku: image[:sku],
        copies: image[:copies],
        assets: [Pwinty::OrderAsset.new(
          url: image[:url],
        )]
      )
    end

    def serializable
      order_attrs = Hash.new
      order_attrs.update(self.attributes)

      order_attrs[:items] = []
      for item in self.items
        order_attrs[:items] << item.serializable
      end

      order_attrs[:recipient] = self.recipient.serializable
      order_attrs
    end

    def submit
      """Send the order to Prodigi."""
      response = Pwinty.conn.post("orders", self.serializable)
      new(response.body['order'])
    end

    def cancel
      """Cancel the order.
      https://www.prodigi.com/print-api/docs/reference/#cancel-an-order
      """
      response = Pwinty.conn.post("orders/#{self.id}/actions/cancel")
      outcome = response.body['outcome']
      case outcome
        when 'failedToCancel'; raise Pwinty::Error, response.body
        when 'actionNotAvailable'; raise Pwinty::OrderActionUnavailable, response.body
      end

      new(response.body['order'])
    end

  end

  protected

  def self.is_limit_reached(number_of_records, limit: 0)
    return false if limit === 0
    return number_of_records >= limit
  end

end
