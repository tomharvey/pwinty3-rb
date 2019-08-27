require 'dry-struct'

module Pwinty

	module Types
  		include Dry::Types()
	end

	class Base < Dry::Struct
		transform_keys(&:to_sym)
	end
end
