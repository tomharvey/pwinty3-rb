module Pwinty

	class PhotoStatus < Pwinty::Base
		attribute :id, Types::Coercible::Integer
		attribute :errors, Types::Array.of(Types::String)
		attribute :warnings, Types::Array.of(Types::String)
	end
end
