require "fileutils"

module Compatriot
  class Runner
    def self.start(app, paths, clock = DateTime)
      runner = new(app, paths, clock)
      runner.create_results_directory
      runner.take_screenshots
      runner.compute_diffs
      runner.make_index_page
      runner
    end

    BROWSERS = ["firefox", "chrome"]

    attr_reader :app, :results_directory

    def initialize(app, paths, clock)
      @app   = app
      @paths = paths
      @clock = clock
      @browsers = {}

      timestamp = @clock.now.strftime("%Y-%m-%d-%H-%M-%S")
      @results_directory = File.join("tmp", "results", timestamp)

      BROWSERS.each do |b|
        @browsers[b] = Compatriot::Browser.new(
          :name => b,
          :screenshot_directory => @results_directory
        )
      end
      @diffs = {}
    end

    def take_screenshots
      @browsers.each do |name, browser_object|
        browser_object.take_screenshots(
          :app   => @app,
          :paths => @paths
        )
      end
    end

    def compute_diffs
      @paths.map do |path|
        @diffs[path] = Compatriot::ImageDiffer.diff(
          @browsers.map do |name, browser_object|
            File.join(
              @results_directory,
              name,
              browser_object.screenshot_for(path)
            )
          end
        )
      end
    end

    def make_index_page
      presenter = Compatriot::ResultsPresenter.new(@results_directory)
      presenter.make_index_page(
        :paths => @paths,
        :browsers => @browsers,
        :diffs => @diffs
      )
    end

    def create_results_directory
      FileUtils.mkdir_p(@results_directory)
    end
  end
end