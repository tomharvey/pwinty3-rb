module Pwinty
  class OrderShipmentCarrier < Pwinty::Base
    attribute? :name, Types::String.optional
    attribute? :service, Types::String.optional
  end
end
