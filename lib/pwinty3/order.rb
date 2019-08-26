require 'json'

require "pwinty3/shipping_info"

module Pwinty3
    class Order < Pwinty3::Base
        attribute :id, Types::Integer
        attribute :address1, Types::String.optional
        attribute :address2, Types::String.optional
        attribute :postalOrZipCode, Types::String.optional
        attribute :countryCode, Types::String
        attribute :addressTownOrCity, Types::String.optional
        attribute :recipientName, Types::String
        attribute :stateOrCounty, Types::String.optional
        attribute :status, Types::String
        attribute :payment, Types::String
        attribute :paymentUrl, Types::String.optional
        attribute :price, Types::Integer
        attribute :shippingInfo, Pwinty3::ShippingInfo
        attribute :images, Types::Array.of(Pwinty3::Image)
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

        def self.list
            response = Pwinty3.conn.get("orders?count=250&offset=0")
            r_data = response.body['data']
            # TODO There is some bug with offset in the API.
            # total_count = r_data['count']
            Pwinty3.collate_results(r_data['content'], self)
        end


        def self.count
            response = Pwinty3.conn.get("orders?count=1&offset=0")
            response.body['data']['count']
        end


        def self.create(**args)
            response = Pwinty3.conn.post("orders", args)
            new(response.body['data'])
        end

        def self.find(id)
            response = Pwinty3.conn.get("orders/#{id}")
            new(response.body['data'])
        end

        def self.update(order, **args)
            update_body = order.to_hash.merge(args)
            response = Pwinty3.conn.put("orders/#{order.id}/", update_body)
            new(response.body['data'])
        end

        def submission_status
            response = Pwinty3.conn.get("orders/#{id}/SubmissionStatus")
            Pwinty3::OrderStatus.new(response.body['data'])
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
            response = Pwinty3.conn.post("orders/#{self.id}/images", image)
            response.body
        end

        def add_images images
            response = Pwinty3.conn.post("orders/#{self.id}/images/batch", images)
            response.body
        end

        protected

        def update_status status
            response = Pwinty3.conn.post("orders/#{self.id}/status", {status: status})
            response.status == 200
        end

    end
end
