#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => error
  $stderr.puts error.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit error.status_code
end

Bundler::GemHelper.install_tasks
desc "Run all of the tests"
Rake::TestTask.new do |config|
  config.libs << 'test'
  config.pattern = 'test/**/test_*'
  config.verbose = true
  config.warning = true
end
