$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'minitest/autorun'
require 'x_proj'

require_relative "sample_app/test_app"

FileUtils.remove_dir(File.join("sample_app", "tmp", "results"), true)
