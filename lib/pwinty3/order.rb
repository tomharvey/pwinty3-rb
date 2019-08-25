require 'json'

module Pwinty3
  	class Order
  		attr_reader :id, :address1, :address2, :postalOrZipCode, :countryCode, :addressTownOrCity, :recipientName, :stateOrCounty, :status, :payment, :paymentUrl, :price, :invoiceAmountNet, :invoiceTax, :invoiceCurrency, :merchantOrderId, :preferredShippingMethod, :mobileTelephone, :created, :lastUpdated, :canCancel, :canHold, :canUpdateShipping, :canUpdateImages, :tag, :errorMessage, :shippingPrice, :shipments

		def initialize(attributes)
			@id = attributes["id"]
			@address1 = attributes["address1"]
			@address2 = attributes["address2"]
			@postalOrZipCode = attributes["postalOrZipCode"]
			@countryCode = attributes["countryCode"]
			@addressTownOrCity = attributes["addressTownOrCity"]
			@recipientName = attributes["recipientName"]
			@stateOrCounty = attributes["stateOrCounty"]
			@status = attributes["status"]
			@payment = attributes["payment"]
			@paymentUrl = attributes["paymentUrl"]
			@price = attributes["price"]
			@invoiceAmountNet = attributes["invoiceAmountNet"]
			@invoiceTax = attributes["invoiceTax"]
			@invoiceCurrency = attributes["invoiceCurrency"]
			@merchantOrderId = attributes["merchantOrderId"]
			@preferredShippingMethod = attributes["preferredShippingMethod"]
			@mobileTelephone = attributes["mobileTelephone"]
			@created = attributes["created"]
			@lastUpdated = attributes["lastUpdated"]
			@canCancel = attributes["canCancel"]
			@canHold = attributes["canHold"]
			@canUpdateShipping = attributes["canUpdateShipping"]
			@canUpdateImages = attributes["canUpdateImages"]
			@tag = attributes["tag"]
			@errorMessage = attributes["errorMessage"]
			@shippingPrice = attributes["shippingInfo"]["price"]
			@shipments = buildShippingObjects attributes["shippingInfo"]["shipments"]
			@images = buildImageObjects attributes["images"]
		end

		def self.list
			response = Pwinty3.conn.get("orders?count=250&offset=0")
			attributes = JSON.parse(response.body)
			total_count = attributes['data']['count']
			content = attributes['data']['content']

			# There is some bug with offset in the API.

			# while content.size < total_count
			# 	puts "#{content.size} is less than #{total_count}"
			# 	puts "#{content[0]['id']} to #{content[-1]['id']}"
			# 	offset = content.size
			# 	puts offset
			# 	response = Pwinty3.conn.get("orders?count=250&offset=#{offset}")
			# 	attributes = JSON.parse(response.body)
			# 	new_content = attributes['data']['content']
			# 	puts "#{new_content[0]['id']} to #{new_content[-1]['id']}"
			# 	content += new_content
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
			attributes = JSON.parse(response.body)
			attributes['data']['count']
		end


	  	def self.create(**args)
	  		response = Pwinty3.conn.post("orders", args.to_json)
	  		attributes = JSON.parse(response.body)
	  		new(attributes['data'])
	  	end

	  	def self.find(id)
	      	response = Pwinty3.conn.get("orders/#{id}")
	      	attributes = JSON.parse(response.body)
	      	new(attributes['data'])
	    end

	  	def update(**args)
	  		response = Pwinty3.conn.put("orders/#{self.id}", args.to_json)
	  		attributes = JSON.parse(response.body)
	  		Pwinty3::Order.find(self.id)
	  	end

	    def submission_status
	    	response = Pwinty3.conn.get("orders/#{id}/SubmissionStatus")
	    	attributes = JSON.parse(response.body)
	    	Pwinty3::OrderStatus.new(attributes['data'])
	    end

	    def update_status status
	    	response = Pwinty3.conn.post("orders/#{self.id}/status", {status: status}.to_json)
	    	if response.status == 200
	    		true
	    	else
	    		false
	    	end
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
	    	attributes = JSON.parse(response.body)
	    end

	    def add_images images
	    	response = Pwinty3.conn.post("orders/#{self.id}/images/batch", images.to_json)
	    	attributes = JSON.parse(response.body)
	    end

	    protected

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
