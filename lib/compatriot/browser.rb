require "fileutils"
require 'capybara/dsl'

module Compatriot
  class Browser
    include Capybara::DSL

    def self.create_browsers(params = {})
      params[:browser_names].collect do |b|
        Compatriot::Browser.new(
          :name => b,
          :screenshot_directory => params[:results_directory]
        )
      end
    end

    attr_reader :name, :screenshot_path

    def initialize(params = {})
      @name                 = params[:name]
      @screenshot_path      = File.join(params[:screenshot_directory], @name)
      @screenshot_locations = {}

      create_screenshot_path
    end

    def initialize_capybara(app)
      driver = "selenium_#{@name}".to_sym
      Capybara.register_driver driver do |a|
        Capybara::Selenium::Driver.new(a, :browser => @name.to_sym)
      end
      Capybara.default_driver = driver
      Capybara.app = app
    end

    def take_screenshots(params = {})
      initialize_capybara(params[:app])
      params[:paths].map { |path| take_screenshot(path) }

      # Reset the selenium session to avoid timeout errors
      Capybara.send(:session_pool).delete_if { |key, value| key =~ /selenium/i }
    end

    def screenshot_for(path)
      @screenshot_locations[path]
    end

    def take_screenshot(path)
      visit path
      filename = next_filename
      Capybara.page.driver.browser.save_screenshot(filename)
      @screenshot_locations[path] = filename
    end

    private

    def next_filename
      @file_id = (@file_id && @file_id + 1) || 1
      file_base_name = "#{@file_id}.png"
      File.join(@screenshot_path, file_base_name)
    end

    def create_screenshot_path
      FileUtils.mkdir_p(@screenshot_path)
    end
  end
end
