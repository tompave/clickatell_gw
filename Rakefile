require 'rake'
require "bundler/gem_tasks"
require 'rbconfig'

OS = RbConfig::CONFIG['host_os']


require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/*_test.rb"
end
