require_relative 'spec_helper'

describe "The very basics" do
  before do
    @current_dir = Dir.getwd
    Dir.chdir(File.join(File.dirname(__FILE__), 'sample_app'))
  end

  after do
    Dir.chdir(@current_dir)
  end

  it "visits an app's homepage using selenium and takes screenshots" do
    @x_proj = XProj.new
    @x_proj.start

    assert File.exists?("x_proj")

    firefox_directory = File.join("x_proj", "firefox")
    chrome_directory  = File.join("x_proj", "chrome")

    assert File.exists?(firefox_directory)
    assert File.exists?(chrome_directory)

    Dir.entries(firefox_directory).size.must_equal(3)
    Dir.entries(chrome_directory).size.must_equal(3)

#    @driver = Capybara::Session.new(:selenium, TestApp).driver
  end
end