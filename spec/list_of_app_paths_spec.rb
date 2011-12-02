require_relative 'spec_helper'
require 'fileutils'
require 'date'
require 'nokogiri'

describe "Hit a list of paths for this app" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))

    fake_date = DateTime.parse("2012-01-02 00:00:00 UTC")
    fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")
    @fixed_clock = OpenStruct.new(:now => fake_date)

    @results_directory = File.join("tmp", "results", fake_date_dir)
    @firefox_directory = File.join(@results_directory, "firefox")
    @chrome_directory  = File.join(@results_directory, "chrome")

    @x = Compatriot::Runner.start(TestApp, ["/", "/chrome-css-bug"], @fixed_clock)
  end

  after do
    Dir.chdir(@current_dir)
  end

  it "takes a screenshot for each path given and diffs them" do
    Dir.glob(File.join(@firefox_directory, "*.png")).size.must_equal 6
    Dir.glob(File.join(@chrome_directory, "*.png")).size.must_equal 2
  end

  it "has 2 rows of results in the table on the results index" do
    results_index = IO.read(File.join(@results_directory, "index.html"))
    xml = Nokogiri::XML(results_index)
    xml.xpath("//tr[td]").size.must_equal(2)
  end

  it "gets a list of the browsers in the results" do
    @x.results.browsers.must_equal(["firefox", "chrome"])
  end

  it "gets a list of the paths in the results" do
    @x.results.paths.must_equal(["/", "/chrome-css-bug"])
  end

  it "gets the filename of the screenshot for a particular browser and path" do
    @x.results.screenshot_for("firefox", "/").must_equal("1.png")
    @x.results.screenshot_for("firefox", "/chrome-css-bug").must_equal("2.png")
    @x.results.screenshot_for("chrome", "/").must_equal("1.png")
    @x.results.screenshot_for("chrome", "/chrome-css-bug").must_equal("2.png")
  end

  it "should have the home page row colored green and the chrome bug row colored red" do
    @x.compute_diffs
  end
end