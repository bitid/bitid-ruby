# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitid/version'

Gem::Specification.new do |spec|
  spec.name          = "bitid"
  spec.version       = Bitid::VERSION
  spec.authors       = ["Eric Larchevêque"]
  spec.email         = ["elarch@gmail.com"]
  spec.description   = %q{Ruby implementation of the BitID authentication protocol}
  spec.summary       = %q{BitID}
  spec.homepage      = "https://github.com/bitid/bitid-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'bitcoin-cigs'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end