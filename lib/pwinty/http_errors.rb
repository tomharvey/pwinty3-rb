module Pwinty
  class HttpErrors < Faraday::Response::Middleware
    def on_complete(env)
      msg = env[:body]
      case env[:status]
      when 401; raise Pwinty::AuthenticationError, msg
      when 403; raise Pwinty::StateIsInvalid, msg
      when 404; raise Pwinty::NotFound, msg
      when 500; raise Pwinty::Error, msg
      end
    end
  end
end
