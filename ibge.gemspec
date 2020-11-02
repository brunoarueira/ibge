# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ibge/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Bruno Arueira"]
  spec.email         = ["contato@brunoarueira.com"]
  spec.description   = %q{Unofficial gem with a bunch of data collected by ibge}
  spec.summary       = %q{Unofficial gem with a bunch of data collected by ibge}
  spec.homepage      = "http://github.com/brunoarueira/ibge"

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.name          = "ibge"
  spec.version       = Ibge::VERSION
  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.add_dependency "spreadsheet", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "= 3.10.0"
end
