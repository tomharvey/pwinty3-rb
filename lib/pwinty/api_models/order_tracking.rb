module Pwinty
  class OrderTracking < Pwinty::Base
    attribute? :number, Types::String.optional
    attribute? :url, Types::String.optional
  end
end
