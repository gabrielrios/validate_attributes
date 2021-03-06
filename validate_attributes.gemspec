# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'validate_attributes/version'

Gem::Specification.new do |spec|
  spec.name          = "validate_attributes"
  spec.version       = ValidateAttributes::VERSION
  spec.authors       = ["Gabriel Rios"]
  spec.email         = ["gabrielfalcaorios@gmail.com"]
  spec.summary       = %q{Allow for validation of only some attributes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('activerecord', '>= 3.0.0')

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency 'appraisal'
end
