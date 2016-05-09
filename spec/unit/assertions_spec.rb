require_relative '../spec_helper'

describe Compatriot::Assertions do
  let(:page) { Page.new }

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
  end

  it 'can assert on assert_no_ui_changes' do
    assert_no_ui_changes('this test')
  end
end
