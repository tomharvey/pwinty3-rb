require 'dry/struct/with_setters'

require "pwinty/shipping_info"

module Pwinty
  class Order < Pwinty::Base
    include Dry::Struct::Setters
    include Dry::Struct::Setters::MassAssignment

    attribute :id, Types::Integer
    attribute :address1, Types::String.optional
    attribute :address2, Types::String.optional
    attribute :postalOrZipCode, Types::String.optional
    attribute :countryCode, Types::String
    attribute :addressTownOrCity, Types::String.optional
    attribute :recipientName, Types::String.optional
    attribute :stateOrCounty, Types::String.optional
    attribute :status, Types::String
    attribute :payment, Types::String
    attribute? :packingSlipUrl, Types::String.optional
    attribute :paymentUrl, Types::String.optional
    attribute :price, Types::Integer
    attribute :shippingInfo, Pwinty::ShippingInfo
    attribute :images, Types::Array.of(Pwinty::Image)
    attribute :merchantOrderId, Types::String.optional
    attribute :preferredShippingMethod, Types::String
    attribute :mobileTelephone, Types::String.optional
    attribute :created, Types::JSON::DateTime
    attribute :lastUpdated, Types::JSON::DateTime
    attribute :canCancel, Types::Bool
    attribute :canHold, Types::Bool
    attribute :canUpdateShipping, Types::Bool
    attribute :canUpdateImages, Types::Bool
    attribute :errorMessage, Types::String.optional
    attribute :invoiceAmountNet, Types::Integer
    attribute :invoiceTax, Types::Integer
    attribute :invoiceCurrency, Types::String.optional
    attribute :tag, Types::String.optional

    def self.list(page_size=50)
      all_orders = list_each_page(page_size)
      Pwinty.collate_results(all_orders, self)
    end

    def self.list_each_page(page_size, page_start=0, total_orders_count=nil)
      all_orders = []
      while total_orders_count.nil? or all_orders.count < total_orders_count
        response = Pwinty.conn.get("orders?limit=#{page_size}&start=#{page_start}")
        total_orders_count ||= response.body['data']['count']
        all_orders = all_orders + response.body['data']['content']
        page_start = page_start + page_size
      end
      all_orders
    end


    def self.count
      response = Pwinty.conn.get("orders?count=1&offset=0")
      response.body['data']['count']
    end


    def self.create(**args)
      response = Pwinty.conn.post("orders", args)
      new(response.body['data'])
    end

    def self.find(id)
      response = Pwinty.conn.get("orders/#{id}")
      new(response.body['data'])
    end

    def update(**args)
      update_body = self.to_hash.merge(args)
      response = Pwinty.conn.put("orders/#{self.id}/", update_body)
      update_instance_attributes(response.body['data'])
    end

    def submission_status
      response = Pwinty.conn.get("orders/#{id}/SubmissionStatus")
      Pwinty::OrderStatus.new(response.body['data'])
    end

    def submit
      self.update_status 'Submitted'
    end

    def cancel
      self.update_status 'Cancelled'
    end

    def hold
      self.update_status 'AwaitingPayment'
    end

    def add_image image
      images = add_images([image])
      self.images
    end

    def add_images images
      response = Pwinty.conn.post("orders/#{self.id}/images/batch", images)
      success = response.status == 200
      unless success
        Pwinty.logger.warn response.body['statusTxt']
      end
      if response.body['data'] && response.body['data']['items']
        images = Pwinty.collate_results(response.body['data']['items'], Pwinty::Image)
        self.images = self.images + images
      end
      self.images
    end

    def update_instance_attributes(attrs)
      self.assign_attributes(attrs)
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
end
