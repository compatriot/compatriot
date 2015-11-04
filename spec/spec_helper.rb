$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require "minitest/autorun"
require "mocha/mini_test"

require 'compatriot'

require_relative "sample_app/sample_app"

# A custom runner to enable before_suite and after_suite setup/teardown.
# http://bfts.rubyforge.org/minitest/index.html
# Only using it to delete the screenshots that result from running the tests
# before running the suite; it's useful to be able to look at the screenshots
# after a test run so we're not deleting them then.

module TestRunner
  def before_setup
    super
    FileUtils.remove_dir(File.join("sample_app", "tmp", "results"), true)
  end
end

class Minitest::Spec
  include TestRunner
end
