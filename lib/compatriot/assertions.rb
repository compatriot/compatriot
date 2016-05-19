require 'compatriot'

module Compatriot
  module Assertions
    def assert_no_ui_changes(title = '')
      class << self
        attr_accessor :compatriot_assertion_titles
        attr_accessor :compatriot_percentages_changed
      end
      self.compatriot_assertion_titles ||= []
      self.compatriot_assertion_titles << title
      self.compatriot_percentages_changed ||= []
      diff_file = Compatriot.filepath_for_screenshot('diffs', Compatriot.filename_for_test(self, title))

      diff = Compatriot.percentage_changed(self, title)
      puts "% diff is #{diff}. #{diff_file}" if Compatriot.show_diffs
      pass = diff <= Compatriot.ui_difference_threshold

      # We are going to allow 1 retry after failure
      # because there is a weird case that keeps
      # reoccurring that seems like the page
      # might still be rendering. It looks like
      # the font spacing is still adjusting slightly
      unless pass
        puts "Found a difference, retrying once"
        sleep 1
        diff = Compatriot.percentage_changed(self, title)
        puts "% diff is #{diff}. #{diff_file}" if Compatriot.show_diffs
        pass = diff <= Compatriot.ui_difference_threshold
      end

      self.compatriot_percentages_changed << diff
      assert pass, "The difference in the page (#{diff}%) is greater then the threshold #{Compatriot.ui_difference_threshold}"
    end
  end
end
