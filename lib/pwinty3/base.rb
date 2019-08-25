require 'dry-struct'
require 'json'

module Pwinty3

	module Types
  		include Dry::Types()
	end

	class Base < Dry::Struct
		transform_keys(&:to_sym)
	end
end
