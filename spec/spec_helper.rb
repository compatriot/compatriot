$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require "minitest/autorun"
require "minitest/reporters"
require "mocha/mini_test"

require 'compatriot'

SCREENSHOTS_DIR      = './tmp/test/screenshots'

module FakeCapybara
  def self.current_session
    Page.new
  end
end

class Page
  def save_screenshot filepath
    root_dir = File.join(File.dirname(__FILE__), './')
    image_name = filepath.include?('control') ? '1' : '2'
    src_img = root_dir + "/images/#{image_name}.png"
    filepath_dir = File.dirname(filepath)
    FileUtils.mkdir_p(filepath_dir) unless File.directory?(filepath_dir)
    FileUtils.cp(src_img, filepath)
    filepath
  end
end

class Minitest::Spec
  include Compatriot::Assertions
  Compatriot.configure do |config|
    config.screenshot_directory = SCREENSHOTS_DIR
    config.framework = FakeCapybara
  end
end
