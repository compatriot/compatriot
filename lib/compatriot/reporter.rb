require 'minitest'

module Compatriot
  class Reporter < Minitest::StatisticsReporter
    attr_accessor :tests

    def initialize(options={})
      super($stdout, options)
      self.tests = []
      Minitest::Reporters.reporters << self
      Minitest::Test.class_eval do
        def run_with_hooks(*args)
          reporter = Compatriot::Reporter
          reporter.before_test(self)
          result = run_without_hooks(*args)
          reporter.after_test(self)
          result
        end

        # alias_method :run_without_hooks, :run
        alias_method :run, :run_with_hooks
      end
    end

    def self.before_test(test)
      puts "running before tests"
    end

    def self.after_test(test)
      puts "running after tests"
    end

    def before_suite(suite)
    end

    def after_suite(suite)
    end

    def record(test)
      super
      tests << test
    end

    def report
      super
    end

  end
end
