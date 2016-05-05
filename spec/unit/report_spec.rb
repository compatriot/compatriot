require_relative '../spec_helper'

describe Compatriot::Reporter do
  REPORT_FILENAME = 'compatriot_report.html'
  before do
    FileUtils.rm(REPORT_FILENAME) if File.exists?(REPORT_FILENAME)
  end

  it 'generates an html file' do
    test1 = stub_everything('test',
                            name: 'test_1_viewing_a_specific_report',
                            location: 'Some description',
                            compatriot_assertion_titles: [ 'did stuff' ],
                            passed?: true)
    test2 = stub_everything('test',
                            name: 'test_2_viewing_a_specific_report_with_a_filter',
                            location: 'Another description',
                            compatriot_assertion_titles: [ 'did other stuff' ],
                            passed?: false)
    tests = [
      test1, test2
    ]
    Compatriot::Reporter.new(tests).run

    assert File.exist?(REPORT_FILENAME), "#{REPORT_FILENAME} not found"
    File.readlines(REPORT_FILENAME).grep(/label class='collapse/).count.must_equal 2
  end

  it 'generates a report even if there were not any assertions made' do
    tests = [stub_everything('test',
                            name: 'test_1_viewing_a_specific_report',
                            location: 'Some description',
                            compatriot_assertion_titles: [ ],
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
                             passed?: true)
            ]
    Compatriot::Reporter.new(tests).run
    assert File.exist?(REPORT_FILENAME), "#{REPORT_FILENAME} not found"
    File.readlines(REPORT_FILENAME).grep(/label class='collapse/).count.must_equal 2
  end
end
