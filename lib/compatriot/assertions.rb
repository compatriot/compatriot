module Compatriot
  module Assertions
    def assert_no_ui_changes(title = '')
      diff = Compatriot.percentage_changed(self, title)
      assert diff <= Compatriot.ui_difference_threshold, "The difference in the page (#{diff}%) is greater then the threshold #{Compatriot.ui_difference_threshold}"
    end
  end
end
