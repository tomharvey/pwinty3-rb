require 'faraday'
require 'faraday_middleware'

require "pwinty/base"
require "pwinty/country"
require "pwinty/http_errors"
require "pwinty/image"
require "pwinty/order"
require "pwinty/order_status"
require 'pwinty/photo_status'
require "pwinty/shipment"
require "pwinty/shipping_info"
require "pwinty/version"

module Pwinty
  class Error < StandardError; end
  class AuthenticationError < Pwinty::Error; end
  class OrderNotFound < Pwinty::Error; end
  class StateIsInvalid < Pwinty::Error; end

  MERCHANT_ID = ENV['PWINTY_MERCHANT_ID']
  API_KEY     = ENV['PWINTY_API_KEY']
  BASE_URL    = ENV['PWINTY_BASE_URL'] || 'https://sandbox.pwinty.com'
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
    "#{Pwinty::BASE_URL}/#{Pwinty::API_VERSION}/"
  end

  def self.headers
    {
      'X-Pwinty-MerchantId' => Pwinty::MERCHANT_ID,
      'X-Pwinty-REST-API-Key' => Pwinty::API_KEY,
    }
  end

  def self.conn
    Faraday.new(url: url, headers: headers) do |config|
      config.request :json
      config.response :json
      config.use Pwinty::HttpErrors
      config.adapter Faraday.default_adapter
    end
  end

  def self.collate_results(response_data, targetted_class)
    collection = []
    response_data.each do |individual_attr|
      collection << targetted_class.new(individual_attr)
    end
    collection
  end
end
