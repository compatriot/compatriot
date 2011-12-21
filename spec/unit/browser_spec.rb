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
    before do
      @b = Compatriot::Browser.new(
        :name => "foo",
        :screenshot_directory => "bar"
      )
    end

    it "registers a new driver" do
      Capybara.expects(:register_driver).with(:selenium_foo)

      @b.initialize_capybara(stub)
    end

    it "sets this driver as the default" do
      Capybara.expects(:default_driver=).with(:selenium_foo)

      @b.initialize_capybara(stub)
    end

    it "sets the Capybara app" do
      app = stub
      Capybara.expects(:app=).with(app)

      @b.initialize_capybara(app)
    end
  end

  describe "take_screenshots" do
    before do
      @b = Compatriot::Browser.new(
        :name => "foo",
        :screenshot_directory => "bar"
      )
    end

    it "calls initialize_capybara once and take_screenshot for each path" do
      app = stub
      @b.expects(:initialize_capybara).with(app)

      @b.expects(:take_screenshot).with("/")
      @b.expects(:take_screenshot).with("/contact")

      @b.take_screenshots(
        :app => app,
        :paths => ["/", "/contact"]
      )
    end
  end

  describe "take_screenshot" do
    before do
      @b = Compatriot::Browser.new(
        :name => "foo",
        :screenshot_directory => "bar"
      )
    end

    it "visits the path" do
      @b.expects(:visit).with("/some_page")

      capybara_browser = stub
      capybara_browser.stubs(:save_screenshot)
      Capybara.page.driver.stubs(:browser).returns(capybara_browser)

      @b.take_screenshot("/some_page")
    end

    it "tells capybara to take a screenshot" do
      @b.stubs(:visit)

      @b.stubs(:next_filename).returns("/where_to_save")
      capybara_browser = stub
      capybara_browser.expects(:save_screenshot).with("bar/foo/where_to_save")
      Capybara.page.driver.stubs(:browser).returns(capybara_browser)

      @b.take_screenshot("/some_page")
    end

    it "increments the filenames" do
      @b.stubs(:visit)

      capybara_browser = stub
      capybara_browser.stubs(:save_screenshot)
      Capybara.page.driver.stubs(:browser).returns(capybara_browser)

      @b.take_screenshot("/some_page")
      @b.take_screenshot("/some_other_page")

      @b.relative_screenshot_for("/some_page").must_equal("foo/1.png")
      @b.relative_screenshot_for("/some_other_page").must_equal("foo/2.png")
    end

  end

  describe "relative_screenshot_for" do
    before do
      @b = Compatriot::Browser.new(
        :name => "foo",
        :screenshot_directory => "bar"
      )
    end

    it "returns nil if there is no screenshot for that path" do
      @b.relative_screenshot_for("/whatever").must_equal(nil)
    end

    it "stores the screenshot location by path" do
      @b.stubs(:visit)
      @b.stubs(:next_filename).returns("/some/location.png")

      capybara_browser = stub
      capybara_browser.stubs(:save_screenshot)
      Capybara.page.driver.stubs(:browser).returns(capybara_browser)

      @b.take_screenshot("/")

      @b.relative_screenshot_for("/").must_equal("foo/some/location.png")
    end
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