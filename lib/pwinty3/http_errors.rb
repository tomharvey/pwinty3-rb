module Pwinty3
	class HttpErrors < Faraday::Response::Middleware
		def on_complete(env)
			msg = env[:body]
			case env[:status]
			when 401; raise Pwinty3::AuthenticationError, msg
			when 403; raise Pwinty3::StateIsInvalid, msg
			when 404; raise Pwinty3::OrderNotFound, msg
			when 500; raise Pwinty3::Error, msg
			end
		end
	end
end
