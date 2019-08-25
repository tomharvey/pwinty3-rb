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
            total_count = response.body['data']['count']
            content = response.body['data']['content']

            # There is some bug with offset in the API.

            # while content.size < total_count
            #   puts "#{content.size} is less than #{total_count}"
            #   puts "#{content[0]['id']} to #{content[-1]['id']}"
            #   offset = content.size
            #   puts offset
            #   response = Pwinty3.conn.get("orders?count=250&offset=#{offset}")
            #   attributes = JSON.parse(response.body)
            #   new_content = attributes['data']['content']
            #   puts "#{new_content[0]['id']} to #{new_content[-1]['id']}"
            #   content += new_content
            # end
            # puts "#{content.size} orders colected"

            orders = []
            content.each do |order_attr|
                orders << new(order_attr)
            end
            orders
        end


        def self.count
            response = Pwinty3.conn.get("orders?count=1&offset=0")
            response.body['data']['count']
        end


        def self.create(**args)
            response = Pwinty3.conn.post("orders", args.to_json)
            new(response.body['data'])
        end

        def self.find(id)
            response = Pwinty3.conn.get("orders/#{id}")
            new(response.body['data'])
        end

        def self.update(id, **args)
            Pwinty3.conn.put("orders/#{id}", args.to_json)
            Pwinty3::Order.find(id)
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
            response = Pwinty3.conn.post("orders/#{self.id}/images", image.to_json)
            response.body
        end

        def add_images images
            response = Pwinty3.conn.post("orders/#{self.id}/images/batch", images.to_json)
            response.body
        end

        protected

        def update_status status
            response = Pwinty3.conn.post("orders/#{self.id}/status", {status: status}.to_json)
            if response.status == 200
                true
            else
                false
            end
        end

        def buildShippingObjects shipments_attrs
            shipments = []
            shipments_attrs.each do |shipment_attrs|
                shipments << Pwinty3::Shipment.new(shipment_attrs)
            end
            shipments
        end

        def buildImageObjects images_attrs
            images = []
            images_attrs.each do |image_attrs|
                images << Pwinty3::Image.new(image_attrs)
            end
            images
        end

    end
end
