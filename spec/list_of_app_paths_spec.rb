require_relative 'spec_helper'
require 'fileutils'
require 'date'
require 'nokogiri'

describe "Hit a list of paths for this app" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))
    FileUtils.remove_dir(File.join("tmp", "results"), true)

    fake_date = DateTime.parse("2012-01-02 00:00:00 UTC")
    fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")
    @fixed_clock = OpenStruct.new(:now => fake_date)

    @results_directory = File.join("tmp", "results", fake_date_dir)
    @firefox_directory = File.join(@results_directory, "firefox")
    @chrome_directory  = File.join(@results_directory, "chrome")

    x = XProj::Runner.start(TestApp, ["/", "/chrome-css-bug"], @fixed_clock)
  end

  after do
    Dir.chdir(@current_dir)
  end

  it "takes a screenshot for each path given" do
    Dir.glob(File.join(@firefox_directory, "*.png")).size.must_equal 2
    Dir.glob(File.join(@chrome_directory, "*.png")).size.must_equal 2
  end

  it "has 2 rows of results in the table on the results index" do
    results_index = IO.read(File.join(@results_directory, "index.html"))
    xml = Nokogiri::XML(results_index)
    xml.xpath("//tr[td]").size.must_equal(2)
  end
end