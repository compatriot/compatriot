require 'compatriot'

module Compatriot
  module Assertions
    def assert_no_ui_changes(title = '')
      class << self
        attr_accessor :compatriot_assertion_titles
      end
      self.compatriot_assertion_titles ||= []
      self.compatriot_assertion_titles << title
      diff = Compatriot.percentage_changed(self, title)
      diff_file = Compatriot.filepath_for_screenshot('diffs', Compatriot.filename_for_test(self, title))
      puts "% diff is #{diff}. #{diff_file}" if Compatriot.show_diffs
      pass = diff <= Compatriot.ui_difference_threshold

      unless pass
        puts "Diff > ThresholdFailed: see #{diff_file}"
      end

      assert pass, "The difference in the page (#{diff}%) is greater then the threshold #{Compatriot.ui_difference_threshold}"
    end
  end
end
