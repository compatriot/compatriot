require "compatriot/assertions"
require "compatriot/version"
require "compatriot/image_differ/image_differ"
require "compatriot/minitest_report_driver"
require "capybara"

module Compatriot
  class << self
    attr_accessor :app, :screenshot_directory,
                  :ui_difference_threshold, :framework,
                  :show_diffs

    def configure
      yield self
    end

    def take_screenshot(test, description)
      filename = filename_for_test(test, description)
      control_image_path = filepath_for_screenshot('control', filename)

      if File.exist?(control_image_path)
        screenshot_type = 'variable'
      else
        screenshot_type = 'control'
      end
      framework.current_session.save_screenshot filepath_for_screenshot(screenshot_type, filename)
    end

    def percentage_changed(test, description = '')
      variable_img_path = take_screenshot(test, description)
      control_img_path = filepath_for_screenshot('control', filename_for_test(test, description))
      diff = Compatriot::ColorDiffer.diff(variable_img_path, control_img_path)
      variable_image = ChunkyPNG::Image.from_file(variable_img_path)
      Compatriot::ColorDiffer.color_difference_percentage(variable_image, diff)
    end

    def filename_for_test(test, description)
      test_name = test.name.match(/test_[0-9]+_(.*)/)[1]
      class_name = test.class.name
      filename = class_name + '_' + test_name
      filename += '_' + description unless description.empty?
      filename.tr(' ', '_').downcase + '.png'
    end

    def filepath_for_screenshot(type, filename)
      File.expand_path(self.screenshot_directory + '/' + type + '/' + filename)
    end

    def relative_filepath_for_screenshot(type, filename)
      self.screenshot_directory + '/' + type + '/' + filename
    end
  end

  Compatriot.configure do |config|
    config.screenshot_directory = './compatriot/screenshots'
    config.ui_difference_threshold  = 0.05
    config.framework = Capybara #only supporting capybara until someone wants to support something else
    config.show_diffs = false
  end
end
