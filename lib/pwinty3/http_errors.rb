module Pwinty3
	class HttpErrors < Faraday::Response::Middleware
		def on_complete(env)
			case env[:status]
			when 401
				raise Pwinty3::AuthenticationError, env[:body]
			when 403
				raise Pwinty3::StateIsInvalid, env[:body]
			when 404
				raise Pwinty3::OrderNotFound, env[:body]
			when 500
				raise Pwinty3::Error, env[:body]
			end
		end
	end
end
