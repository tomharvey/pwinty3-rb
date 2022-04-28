require 'dry/struct/with_setters'


module Pwinty

  DEFAULT_PAGE_SIZE = 10

  class OrderRecipientAddress < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-address"""
    attribute? :line1, Types::String.optional
    attribute? :line2, Types::String.optional
    attribute? :postalOrZipCode, Types::String.optional
    attribute? :countryCode, Types::String.optional
    attribute? :townOrCity, Types::String.optional
    attribute? :stateOrCounty, Types::String.optional
  end

  class OrderRecipient < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-recipient"""
    attribute? :name, Types::String.optional
    attribute? :email, Types::String.optional
    attribute? :phoneNumber, Types::String.optional
    attribute? :address, Pwinty::OrderRecipientAddress
  end

  class OrderAsset < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-asset"""
    attribute? :printArea, Types::String.default('default')
    attribute? :url, Types::String
  end

  class OrderItem < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-item"""
    attribute? :id, Types::String.optional
    attribute? :merchantReference, Types::String.optional
    attribute? :sku, Types::String
    attribute? :copies, Types::Integer
    attribute? :sizing, Types::String.default('fillPrintArea')
    attribute? :assets, Types::Array.of(Pwinty::OrderAsset)
    attribute? :attributes, Types::Hash
  end

  class Order < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object"""
    include Dry::Struct::Setters
    include Dry::Struct::Setters::MassAssignment

    attribute? :id, Types::String.optional
    attribute? :created, Types::String.optional
    attribute? :callbackUrl, Types::String.optional
    attribute? :merchantReference, Types::String.optional
    attribute? :shippingMethod, Types::String
    attribute? :idempotencyKey, Types::String.optional
    attribute? :recipient, Pwinty::OrderRecipient
    attribute? :items, Types::Array.of(Pwinty::OrderItem)

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

    def submit
      """Send the order to Prodigi."""
      response = Pwinty.conn.post("orders", self.to_post_body)
      new(response.body['order'])
    end

    def self.find(id)
      response = Pwinty.conn.get("orders/#{id}")
      new(response.body['order'])
    end

    def submission_status
      response = Pwinty.conn.get("orders/#{id}/SubmissionStatus")
      new(response.body['order'])
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

    def to_post_body
      order_attrs = Hash.new
      order_attrs.update(self.attributes)

      order_attrs[:items] = []
      for item in self.items
        item_hash = Hash.new
        item_hash.update(item.attributes)
        item_hash[:assets] = []
        for asset in item.assets
          item_hash[:assets] << asset.attributes 
        end
        order_attrs[:items] << item_hash
      end

      order_attrs[:recipient] = self.recipient.attributes
      order_attrs[:recipient][:address] = self.recipient.address.attributes

      order_attrs
    end

    protected

    def update_status status
      response = Pwinty.conn.post("orders/#{self.id}/status", {status: status})
      success = response.status == 200
      unless success
        Pwinty.logger.warn response.body['statusTxt']
      end
      success
    end

  end

  protected

  def self.is_limit_reached(number_of_records, limit: 0)
    return false if limit === 0
    return number_of_records >= limit
  end

end