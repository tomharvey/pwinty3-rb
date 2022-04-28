
module Pwinty

  class OrderStatus < Pwinty::Base
    attribute :id, Types::Coercible::Integer
    attribute :isValid, Types::Bool
    

    def self.check(id)
      response = Pwinty.conn.get("orders/#{id}/SubmissionStatus")
      new(response.body['data'])
    end
  end
end
