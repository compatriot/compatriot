require 'minitest'
require 'compatriot/reporter'

module Compatriot
  class MinitestReportDriver < Minitest::StatisticsReporter
    attr_accessor :tests

    def initialize(options={})
      super($stdout, options)
      self.tests = []
    end

    def before_test(test)
    end

    def after_test(test)
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
      Compatriot::Reporter.new(tests).run
    end

  end
end
