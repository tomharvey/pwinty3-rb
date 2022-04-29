module Pwinty
  class OrderRecipientAddress < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#order-object-address"""
    attribute? :line1, Types::String.optional
    attribute? :line2, Types::String.optional
    attribute? :postalOrZipCode, Types::String.optional
    attribute? :countryCode, Types::String.optional
    attribute? :townOrCity, Types::String.optional
    attribute? :stateOrCounty, Types::String.optional
  end
end
