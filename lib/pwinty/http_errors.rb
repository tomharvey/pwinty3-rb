module Pwinty
  class HttpErrors < Faraday::Response::Middleware
    def on_complete(env)
      msg = env[:body]
      case env[:status]
        when 400; raise Pwinty::ValidationError, msg
        when 401; raise Pwinty::AuthenticationError, msg
        when 404; raise Pwinty::NotFound, msg
        when 405; raise Pwinty::MethodNotAllowed, msg
        when 415; raise Pwinty::InvalidContentTypeHeader, msg
        when 500; raise Pwinty::Error, msg
      end
    end
  end
end
