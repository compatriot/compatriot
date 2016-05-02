require 'haml'

module Compatriot
  class Reporter
    attr_accessor :tests

    def initialize(tests)
      @tests = tests
    end

    def run
      $tests = tests.sort_by {|t| (t.passed? ? 1 : 0) }
      file_path = File.expand_path('../report_template.html.haml', __FILE__)
      template = File.read(file_path)
      engine = Haml::Engine.new(template)
      File.write 'compatriot_report.html',engine.render
    end
  end
end
