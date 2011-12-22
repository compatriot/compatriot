#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

desc "Run tests"
task :test do
  test_task = Rake::TestTask.new("tests") do |t|
    t.test_files = Dir.glob(File.join("spec", "**", "*_spec.rb"))
  end
  task("tests").execute
end

desc "Run tests"
task :spec do
  task("test").execute
end

task :travis do
  puts "Grabbing chromedriver..."
  mkdir_p "/tmp/bin"
  system "cd /tmp/bin && wget http://chromium.googlecode.com/files/chromedriver_linux32_16.0.902.0.zip && unzip chromedriver_linux32_16.0.902.0.zip"

  puts "Starting to run tests..."
  system("export PATH=/tmp/bin:$PATH && export DISPLAY=:99.0 && bundle exec rake test")
  raise "`rake test` failed!" unless $?.exitstatus == 0
end
