# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'clickatell_gw/version'


Gem::Specification.new do |spec|
  spec.name        = 'clickatell_gw'
  spec.summary     = %Q{summary - todo}
  spec.description = %Q{description - todo}

  spec.version     = ClickatellGW::VERSION
  #spec.date        = ClickatellGw::Meta.date_string

  spec.author      = 'Tommaso Pavese'
  spec.homepage    = 'https://github.com/tompave/clickatell_gw'
  spec.license     = 'MIT'

  spec.platform    = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.0.0'


  spec.add_runtime_dependency 'net-http-persistent', '~> 2.9.4'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency "minitest", "~> 5.2.3"
  spec.add_development_dependency "webmock", "~> 1.17.2"
  spec.add_development_dependency 'pry'


  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
