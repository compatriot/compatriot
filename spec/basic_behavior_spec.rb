require_relative 'spec_helper'
require 'fileutils'
require 'date'

describe "The very basics" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))
    FileUtils.rmdir(File.join("tmp", "results"))
  end

  after do
    Dir.chdir(@current_dir)
  end

  it "creates directories in which to store the results based on the date" do
    fixed_clock = OpenStruct.new(:now => DateTime.parse("2012-01-01 00:00:00 UTC"))

    @x_proj = XProj::Runner.new(fixed_clock)
    @x_proj.start

    results_directory = File.join("tmp", "results", "2012-01-01-00-00-00")
    assert File.exists?(results_directory)

    firefox_directory = File.join(results_directory, "firefox")
    chrome_directory  = File.join(results_directory, "chrome")

    assert File.exists?(firefox_directory)
    assert File.exists?(chrome_directory)
  end
end