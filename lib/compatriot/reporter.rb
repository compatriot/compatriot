require 'haml'

module Compatriot
  class Reporter
    attr_accessor :tests

    def initialize(tests)
      @tests = tests
    end

    def run
      $tests = format(tests)
      file_path = File.expand_path('../report_template.html.haml', __FILE__)
      template = File.read(file_path)
      engine = Haml::Engine.new(template)
      File.write 'compatriot_report.html',engine.render
    end

    def format(tests)
      formated_tests = []
      tests.each do |test|
        next unless test.respond_to? :compatriot_assertion_titles
        test.compatriot_assertion_titles.each_with_index do |title,j|
          formated_test = {
            label: test.location + ':' + title + ':' + test.compatriot_percentages_changed[j].to_s + "% difference",
            percentage_changed: test.compatriot_percentages_changed[j],
            status: test.passed? ? "passed" : "failed",
            control_image_path: Compatriot.filepath_for_screenshot('control', Compatriot.filename_for_test(test, title)),
            variable_image_path: Compatriot.filepath_for_screenshot('variable', Compatriot.filename_for_test(test, title)),
            diff_image_path: Compatriot.filepath_for_screenshot('diffs', Compatriot.filename_for_test(test, title)),
          }
          formated_tests << formated_test
        end
      end
      formated_tests.sort_by { |k| k[:percentage_changed] }.reverse
    end
  end
end
