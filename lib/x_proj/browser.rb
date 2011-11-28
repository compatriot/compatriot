require "fileutils"
require 'capybara/dsl'

module XProj
  class Browser
    include Capybara::DSL

    def initialize(browser_name)
      @browser_name        = browser_name
      @browser_selenium_id = translate_to_selenium(@browser_name)
      @file_id = 1
      @results = {}
    end

    def take_screenshots(params)
      @results_directory = params[:results_directory]
      @app = params[:app]
      @paths = params[:paths]

      initialize_capybara

      @paths.each do |path|
        visit path
        @results[path] = screenshot
      end
      @results
    end

    def initialize_capybara
      driver = "selenium_#{@browser_name}".to_sym
      Capybara.register_driver driver do |app|
        Capybara::Selenium::Driver.new(app, :browser => @browser_selenium_id)
      end
      Capybara.default_driver = driver
      Capybara.app = @app
    end

    def screenshot
      file_base_name = "#{@file_id}.png"
      @file_id += 1
      filepath = File.join(screenshot_path, file_base_name)
      Capybara.page.driver.browser.save_screenshot(filepath)
      file_base_name
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
