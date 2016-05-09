require_relative '../spec_helper'

describe Compatriot::Reporter do
  describe 'tests format' do

    it 'sorts the tests by percentage changed' do
      test1 = stub_everything('test',
                              name: 'test_1_viewing_a_specific_report',
                              location: 'Some description',
                              compatriot_assertion_titles: [ 'did stuff','moar' ],
                              compatriot_percentages_changed: [ 0.02 , 0.04 ],
                              passed?: true)
      test2 = stub_everything('test',
                              name: 'test_2_viewing_a_specific_report_with_a_filter',
                              location: 'Another description',
                              compatriot_assertion_titles: [ 'did other stuff', 'moar other stuff' ],
                              compatriot_percentages_changed: [ 0.03, 0.8 ],
                              passed?: false)
      tests = [test1, test2]
      formated_tests = Compatriot::Reporter.new(tests).format(tests)
      formated_tests.map { |t| t[:percentage_changed] }.must_equal [ 0.8, 0.04, 0.03, 0.02 ]
    end

    it 'labels the tests names' do
      tests = [stub_everything('test',
                               name: 'test_1_viewing_a_specific_report',
                               location: 'Some description',
                               compatriot_assertion_titles: [ 'did stuff','moar' ],
                               compatriot_percentages_changed: [ 0.02 , 0.04 ],
                               passed?: true)]
      formated_tests = Compatriot::Reporter.new(tests).format(tests)
      labels = formated_tests.map { |t| t[:label] }
      labels.must_equal ["Some description:moar:0.04% difference","Some description:did stuff:0.02% difference"]
    end

    it 'image paths are relative' do
      tests = [stub_everything('test',
                               name: 'test_1_viewing_a_specific_report',
                               location: 'Some description',
                               compatriot_assertion_titles: [ 'did stuff' ],
                               compatriot_percentages_changed: [ 0.02 ],
                               passed?: true)]
      formated_test = Compatriot::Reporter.new(tests).format(tests)[0]
      formated_test[:control_image_path].must_equal "./tmp/test/screenshots/control/mocha::mock_viewing_a_specific_report_did_stuff.png"
      formated_test[:variable_image_path].must_equal "./tmp/test/screenshots/variable/mocha::mock_viewing_a_specific_report_did_stuff.png"
      formated_test[:diff_image_path].must_equal "./tmp/test/screenshots/diffs/mocha::mock_viewing_a_specific_report_did_stuff.png"
    end
  end

  describe 'html file' do
    REPORT_FILENAME = 'compatriot_report.html'
    before do
      FileUtils.rm(REPORT_FILENAME) if File.exists?(REPORT_FILENAME)
    end

    it 'generates an html file' do
      test1 = stub_everything('test',
                              name: 'test_1_viewing_a_specific_report',
                              location: 'Some description',
                              compatriot_assertion_titles: [ 'did stuff' ],
                              compatriot_percentages_changed: [ 0.02 ],
                              passed?: true)
      test2 = stub_everything('test',
                              name: 'test_2_viewing_a_specific_report_with_a_filter',
                              location: 'Another description',
                              compatriot_assertion_titles: [ 'did other stuff' ],
                              compatriot_percentages_changed: [ 0.8 ],
                              passed?: false)
      tests = [test1, test2]
      Compatriot::Reporter.new(tests).run

      assert File.exist?(REPORT_FILENAME), "#{REPORT_FILENAME} not found"
      File.readlines(REPORT_FILENAME).grep(/label class='collapse/).count.must_equal 2
    end

    it 'generates a report even if there were not any assertions made' do
      tests = [stub_everything('test',
                               name: 'test_1_viewing_a_specific_report',
                               location: 'Some description',
                               compatriot_assertion_titles: [ ],
                               compatriot_percentages_changed: [ 0.02 ],
                               passed?: true)
              ]
      Compatriot::Reporter.new(tests).run
      assert File.exist?(REPORT_FILENAME), "#{REPORT_FILENAME} not found"
      File.readlines(REPORT_FILENAME).grep(/label class='collapse/).count.must_equal 0
    end

    it 'handles multiple assertions in one test' do
      tests = [stub_everything('test',
                               name: 'test_1_viewing_a_specific_report',
                               location: 'Some description',
                               compatriot_assertion_titles: [ 'first assertion', 'second assertion' ],
                               compatriot_percentages_changed: [ 0.02 , 0.01 ],
                               passed?: true)
              ]
      Compatriot::Reporter.new(tests).run
      assert File.exist?(REPORT_FILENAME), "#{REPORT_FILENAME} not found"
      File.readlines(REPORT_FILENAME).grep(/label class='collapse/).count.must_equal 2
    end
  end

end
