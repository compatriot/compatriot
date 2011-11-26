require_relative 'spec_helper'
require 'fileutils'
require 'date'

describe "The very basics" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))
    FileUtils.remove_dir(File.join("tmp", "results"))

    fake_date = DateTime.parse("2012-01-01 00:00:00 UTC")
    fake_date_dir = fake_date.strftime("%Y-%m-%d-%H-%M-%S")

    fixed_clock = OpenStruct.new(:now => fake_date)
    @x_proj = XProj::Runner.new(TestApp, fixed_clock)
    @x_proj.start

    @results_directory = File.join("tmp", "results", fake_date_dir)
    @firefox_directory = File.join(@results_directory, "firefox")
    @chrome_directory  = File.join(@results_directory, "chrome")
  end

  after do
    Dir.chdir(@current_dir)
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

  # it "creates an index page that shows the screenshots" do
  #
  # end
end