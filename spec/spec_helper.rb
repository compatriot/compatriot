$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))

require 'rubygems'
gem 'minitest' # ensures you're using the gem, and not the built in MT
require 'minitest/autorun'
require 'compatriot'

require_relative "sample_app/test_app"

# A custom runner to enable before_suite and after_suite setup/teardown.
# http://bfts.rubyforge.org/minitest/index.html
# Only using it to delete the screenshots that result from running the tests
# before running the suite; it's useful to be able to look at the screenshots
# after a test run so we're not deleting them then.

module MiniTestWithHooks
  class Unit < MiniTest::Unit
    def before_suites
    end

    def after_suites
    end

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end
  end
end

module MiniTestRemoveScreenshots
  class Unit < MiniTestWithHooks::Unit

    def before_suites
      super
      FileUtils.remove_dir(File.join("sample_app", "tmp", "results"), true)
    end

    def after_suites
      super
    end
  end
end

MiniTest::Unit.runner = MiniTestRemoveScreenshots::Unit.new