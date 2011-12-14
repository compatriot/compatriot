require_relative 'spec_helper'
require 'fileutils'
require 'date'
require 'nokogiri'

describe "Hit a list of paths for this app" do
  it "takes screenshots, diffs them, and creates an index" do
    root_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))

    results_tmp_dir = File.join("tmp", "results")

    FileUtils.remove_dir(results_tmp_dir, true)

    Compatriot.app = TestApp
    Compatriot.run(%w[
      /
      /chrome-css-bug
    ])

    current_results_dir = (Dir.entries(results_tmp_dir) - [".", ".."]).first
    current_results_dir = File.join(results_tmp_dir, current_results_dir)

    firefox_dir = File.join(current_results_dir, "firefox")
    chrome_dir  = File.join(current_results_dir, "chrome")

    Dir.glob(File.join(firefox_dir, "*.png")).size.must_equal 4
    Dir.glob(File.join(chrome_dir, "*.png")).size.must_equal 2

    results_index = IO.read(File.join(current_results_dir, "index.html"))
    xml = Nokogiri::XML(results_index)
    xml.xpath("//tr[td]").size.must_equal(2)

    Dir.chdir(root_dir)
  end
end