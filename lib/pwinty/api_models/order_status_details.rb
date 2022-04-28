module Pwinty
  class OrderStatusDetails < Pwinty::Base
    """https://www.prodigi.com/print-api/docs/reference/#status-status-object-details"""
    attribute? :downloadAssets, Types::String.optional
    attribute? :allocateProductionLocation, Types::String.optional
    attribute? :printReadyAssetsPrepared, Types::String.optional
    attribute? :inProduction, Types::String.optional
    attribute? :shipping, Types::String.optional
  end
end
