require_relative '../spec_helper'

describe Compatriot::Browser do
  describe "self#create_browsers" do
    it "creates a browser object for each browser name given to it" do
      browsers = ["linx", "dolphin HD"] # Selenium totally doesn't work w/these
      fake_directory = "/some/location"

      linx = stub
      dolphin = stub

      Compatriot::Browser.expects(:new).with(
        :name => "linx",
        :screenshot_directory => fake_directory
      ).returns(linx)

      Compatriot::Browser.expects(:new).with(
        :name => "dolphin HD",
        :screenshot_directory => fake_directory
      ).returns(dolphin)

      results = Compatriot::Browser.create_browsers(
        :browser_names => browsers,
        :results_directory => fake_directory
      )
      results.must_equal([linx, dolphin])
    end
  end

  describe "initialize_capybara" do
  end

  describe "take_screenshots" do
  end

  describe "screenshot_for" do
  end

  describe "screenshot" do
  end

  describe "screenshot_path" do
    it "adds the browser name to the screenshot dir and creates it" do
      FileUtils.expects(:mkdir_p).with("foo/bar/hi")

      c = Compatriot::Browser.new(
        :name => "hi",
        :screenshot_directory => "foo/bar"
      )

      c.screenshot_path.must_equal("foo/bar/hi")
    end
  end
end