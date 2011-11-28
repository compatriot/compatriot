require "fileutils"
require 'capybara/dsl'

module XProj
  class Browser
    include Capybara::DSL

    def initialize(browser_name, app, results_directory)
      @browser_name        = browser_name
      @browser_selenium_id = translate_to_selenium(@browser_name)
      @results_directory   = results_directory
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
      filepath = File.join(screenshot_path, file_base_name)
      Capybara.page.driver.browser.save_screenshot(filepath)
    end

    def screenshot_path
      return @screenshot_path if @screenshot_path
      @screenshot_path = "#{@results_directory}/#{@browser_name}"
      FileUtils.mkdir_p(@screenshot_path)
      @screenshot_path
    end

    private

    def translate_to_selenium(browser_name)
      browser_name.to_sym
    end
  end
end
