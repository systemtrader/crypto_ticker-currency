# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require 'crypto_ticker/version'

Gem::Specification.new do |spec|
  spec.name          = "crypto_ticker"
  spec.version       = CryptoTicker::VERSION
  spec.authors       = ["Nathan Marley"]
  spec.email         = ["nmarley@blackcarrot.be"]
  spec.description   = %q{Collection of public data API urls for various online
                          crypto-currency exchanges, e.g. MtGox, BTC-e, etc.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/nmarley/crypto_ticker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
