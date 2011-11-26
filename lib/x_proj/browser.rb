require "fileutils"
require 'capybara/dsl'

module XProj
  class Browser
    include Capybara::DSL

    def initialize(browser_name, app, results_directory)
      @browser_name        = browser_name
      @browser_selenium_id = translate_to_selenium(@browser_name)
      @screenshot_dir      = "#{results_directory}/#{@browser_name}"

      FileUtils.mkdir_p(@screenshot_dir)

      @app = app
    end

    def start
      driver = "selenium_#{@browser_name}".to_sym
      Capybara.register_driver driver do |app|
        Capybara::Selenium::Driver.new(app, :browser => @browser_selenium_id)
      end
      Capybara.default_driver = driver
      Capybara.app = @app

      visit "/"
      file_base_name = "1.png"
      screenshot_path = File.join(@screenshot_dir, file_base_name)
      Capybara.page.driver.browser.save_screenshot(screenshot_path)
    end

    private

    def translate_to_selenium(browser_name)
      browser_name.to_sym
    end
  end
end
