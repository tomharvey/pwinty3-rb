require 'faraday'
require 'faraday_middleware'

require "pwinty3/base"
require "pwinty3/country"
require "pwinty3/http_errors"
require "pwinty3/image"
require "pwinty3/order"
require "pwinty3/order_status"
require 'pwinty3/photo_status'
require "pwinty3/shipment"
require "pwinty3/shipping_info"
require "pwinty3/version"

module Pwinty3
    class Error < StandardError; end
    class AuthenticationError < Pwinty3::Error; end
    class OrderNotFound < Pwinty3::Error; end
    class StateIsInvalid < Pwinty3::Error; end

    MERCHANT_ID = ENV['PWINTY3_MERCHANT_ID']
    API_KEY     = ENV['PWINTY3_API_KEY']
    BASE_URL    = ENV['PWINTY3_BASE_URL'] || 'https://sandbox.pwinty.com'
    API_VERSION = 'v3.0'

    class << self
        attr_accessor :logger
        def logger
            @logger ||= Logger.new($stdout).tap do |log|
                log.progname = self.name
            end
        end
    end

    def self.url
        "#{Pwinty3::BASE_URL}/#{Pwinty3::API_VERSION}/"
    end

    def self.headers
        {
            'X-Pwinty-MerchantId' => Pwinty3::MERCHANT_ID,
            'X-Pwinty-REST-API-Key' => Pwinty3::API_KEY,
        }
    end

    def self.conn
        Faraday.new(url: url, headers: headers) do |config|
            config.request :json
            config.response :json
            config.use Pwinty3::HttpErrors
            config.adapter Faraday.default_adapter
        end
    end

    def self.collate_results(response_data, classType)
        collection = []
        response_data.each do |individual_attr|
            collection << classType.new(individual_attr)
        end
        collection
    end
end
