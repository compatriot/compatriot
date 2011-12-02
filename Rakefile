#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

desc "Run tests"
task :test do
  test_task = Rake::TestTask.new("tests") do |t|
    t.test_files = Dir.glob(File.join("spec", "**", "*_spec.rb"))
  end
  task("tests").execute
begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => error
  $stderr.puts error.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit error.status_code
end

Bundler::GemHelper.install_tasks
