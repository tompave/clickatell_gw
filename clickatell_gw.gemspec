
# pushes the lib directory at the beginning of the ruby env $LOAD_PATH
# lib_path = File.expand_path("../lib", __FILE__)
# $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)


Gem::Specification.new do |s|
  s.name        = 'clickatell_gw'
  s.summary     = %Q{summary - todo}
  s.description = %Q{description - todo}

  s.version     = "0.0.1"#ClickatellGw::Meta::VERSION
  #s.date        = ClickatellGw::Meta.date_string

  s.author      = 'Tommaso Pavese'
  s.homepage    = 'https://github.com/tompave/clickatell_gw'
  s.license     = 'MIT'

  s.platform    = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'


  s.add_runtime_dependency 'net-http-persistent', '~> 2.9.4'

  s.add_development_dependency 'rake',          '~> 10.0'

  #s.files        = Dir.glob('{bin,images,lib}/**/*') + %w[CHANGELOG.md LICENSE man/guard.1 man/guard.1.html README.md]
  s.executables  << 'clickatell_gw'
  s.require_path = 'lib'
end
