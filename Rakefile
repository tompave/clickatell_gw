require 'rake'
require "bundler/gem_tasks"
require 'rbconfig'

OS = RbConfig::CONFIG['host_os']

Rake::TestTask.new do |t|
  t.libs << 'test'
end