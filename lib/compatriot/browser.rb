require "fileutils"
require 'capybara/dsl'

module Compatriot
  class Browser
    include Capybara::DSL

    def self.create_browsers(params = {})
      browsers = {}
      params[:browser_names].each do |b|
        browsers[b] = Compatriot::Browser.new(
          :name => b,
          :screenshot_directory => params[:results_directory]
        )
      end
      browsers
    end

    attr_reader :screenshot_locations

    def initialize(params = {})
      @screenshot_directory = params[:screenshot_directory]
      @browser_name         = params[:name]
      @browser_selenium_id  = translate_to_selenium(@browser_name)
      @file_id = 1
      @screenshot_locations = {}
    end

    def initialize_capybara(app)
      driver = "selenium_#{@browser_name}".to_sym
      Capybara.register_driver driver do |a|
        Capybara::Selenium::Driver.new(a, :browser => @browser_selenium_id)
      end
      Capybara.default_driver = driver
      Capybara.app = app
    end

    def take_screenshots(params = {})
      initialize_capybara(params[:app])
      params[:paths].each do |path|
        visit path
        @screenshot_locations[path] = screenshot
      end
      # Reset the selenium session to avoid timeout errors
      Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
    end

    def screenshot_for(path)
      @screenshot_locations[path]
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
      @screenshot_path = "#{@screenshot_directory}/#{@browser_name}"
      FileUtils.mkdir_p(@screenshot_path)
      @screenshot_path
    end

    private

    def translate_to_selenium(browser_name)
      browser_name.to_sym
    end
  end
end
