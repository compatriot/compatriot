require_relative 'spec_helper'
require 'fileutils'
require 'date'

describe "The very basics" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))
    FileUtils.remove_dir(File.join("tmp", "results"), true)

    fake_date = DateTime.parse("2012-01-01 00:00:00 UTC")
    fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")
    @fixed_clock = OpenStruct.new(:now => fake_date)

    @results_directory = File.join("tmp", "results", fake_date_dir)
    @firefox_directory = File.join(@results_directory, "firefox")
    @chrome_directory  = File.join(@results_directory, "chrome")
  end

  after do
    Dir.chdir(@current_dir)
  end

  it "holds onto the app we give it" do
    x = XProj::Runner.new(TestApp, @fixed_clock)
    x.app.must_equal(TestApp)
  end

  it "names a results directory based on the clock" do
    x = XProj::Runner.new(TestApp, @fixed_clock)
    x.results_directory.must_equal(@results_directory)
  end

  describe "self#start" do
    before do
      XProj::Runner.start(TestApp, @fixed_clock)
    end

    it "creates directories in which to store the results based on the date" do
      assert File.exists?(@results_directory)
      assert File.exists?(@firefox_directory)
      assert File.exists?(@chrome_directory)
    end

    it "visits the home page and takes 1 screenshot per browser" do
      Dir.glob(File.join(@firefox_directory, "*.png")).size.must_equal 1
      Dir.glob(File.join(@chrome_directory, "*.png")).size.must_equal 1
    end

    it "creates an index page that shows the screenshots" do
      assert File.exists?(File.join(@results_directory, "index.html"))
    end
  end
end