# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fancy_print/version'

Gem::Specification.new do |spec|
  spec.name          = "fancy_print"
  spec.version       = FancyPrint::VERSION
  spec.authors       = ["nounch"]
  spec.email         = ["nounch@outlook.com"]
  spec.summary       =
    "Let's you print to the browser - graphics, code, objects, ..."
  spec.description   = <<-DESCRIPTION
Runs a tiny local server that you can print to from inside your code
without interrupting your program flow. The output is visible right inside
your browser.
DESCRIPTION
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
