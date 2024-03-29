
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pwinty/version"

Gem::Specification.new do |spec|
  spec.name          = "pwinty"
  spec.version       = Pwinty::VERSION
  spec.authors       = ["Thomas Harvey"]
  spec.email         = ["tom@alush.co.uk"]

  spec.summary       = %q{Order photo prints through the Prodigi Pwinty API}
  spec.description   = "This wraps the Pwinty API at version 4 and aims to make your ruby life easier when interacting with the API."
  spec.homepage      = "https://github.com/tomharvey/pwinty3-rb"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://www.prodigi.com/print-api/docs/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.14"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "dotenv", "~> 2.7.5"

  spec.add_dependency "dry-struct", "~> 1.0"
  spec.add_dependency "dry-struct-setters", "~> 0.4"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "faraday_middleware", "~> 1.2"
  spec.add_dependency "json", "~> 2.6"
end
