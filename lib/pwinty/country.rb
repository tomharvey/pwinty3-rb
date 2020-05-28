module Pwinty

  class Country < Pwinty::Base
    attribute :name, Types::String
    attribute :isoCode, Types::String

    def self.list
      response = Pwinty.conn.get("countries")
      Pwinty.collate_results(response.body['data'], self)
    end
  end
end
