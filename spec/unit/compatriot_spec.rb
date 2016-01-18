require_relative '../spec_helper'

describe Compatriot do
  let(:class_stub)   { stub_everything('class', name: 'important_test') }
  let(:stubbed_test) { stub_everything('test', name: 'test_001_will do something important', class: class_stub) }
  let(:page)         { Page.new }

  SCREENSHOTS_DIR      = './tmp/test/screenshots'
  CONTROL_IMG_FILENAME = 'important_test_will_do_something_important_and_has_a_description.png'
  CONTROL_IMG          = "#{SCREENSHOTS_DIR}/control/#{CONTROL_IMG_FILENAME}"
  CONTROL_IMG2         = "#{SCREENSHOTS_DIR}/control/important_test_will_do_something_important_another.png"
  VARIABLE_IMG         = "#{SCREENSHOTS_DIR}/variable/important_test_will_do_something_important_and_has_a_description.png"
  DIFF_IMG             = "#{SCREENSHOTS_DIR}/diffs/color_variable_vs_control_important_test_will_do_something_important_and_has_a_description.png"

  def setup_control_image
    Page.new.save_screenshot CONTROL_IMG
  end

  before do
    FileUtils.remove_dir(SCREENSHOTS_DIR) if File.directory?(SCREENSHOTS_DIR)
    Compatriot.configure do |config| 
      config.screenshot_directory = SCREENSHOTS_DIR
    end
  end

  describe 'no control image is found' do
    it 'it will create one' do
      Compatriot.take_screenshot(page, stubbed_test, 'and has a description')
      Compatriot.take_screenshot(page, stubbed_test, 'another')

      assert File.exist?(CONTROL_IMG), 'control image not found'
      assert File.exist?(CONTROL_IMG2), 'control image not found'
    end
  end

  describe 'control image is found' do
    before do
      setup_control_image
    end

    it 'stores a variable image' do
      Compatriot.take_screenshot(page, stubbed_test, 'and has a description')
      assert File.exist?(VARIABLE_IMG)
    end

    it 'stores the image difference' do
      Compatriot.percentage_changed(page, stubbed_test, 'and has a description')
      assert File.exist?(DIFF_IMG)
    end

    it 'returns the percentage difference' do
      result = Compatriot.percentage_changed(page, stubbed_test, 'and has a description')
      assert_equal(0.81, result.round(2))
    end

    it 'returns 0 % if there is no difference' do
      Compatriot::ColorDiffer.stubs(:diff).returns([])
      result = Compatriot.percentage_changed(page, stubbed_test, 'and has a description')
      assert_equal(0.0, result.round(2))
    end
  end

  describe 'configuration' do
    before do
      @screenshot_directory = 'tmp/test_configuration'
      @control_file = @screenshot_directory + '/control/' + CONTROL_IMG_FILENAME
      Compatriot.configure do |config|
        config.screenshot_directory = @screenshot_directory
      end
      FileUtils.remove_dir(@screenshot_directory) if File.directory?(SCREENSHOTS_DIR)
    end

    it 'can set the screenshot directory' do
      Compatriot.take_screenshot(page, stubbed_test, 'and has a description')
      assert File.exist?(@control_file), 'control image not found'
    end
  end
end
