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

    attr_reader :app, :results

    def initialize(app, paths, clock)
      @app   = app
      @paths = paths
      @clock = clock
      @results = Compatriot::Results.new
    end

    def take_screenshots
      BROWSERS.each do |b|
        @results.take_screenshots(
          :browser           => b,
          :app               => @app,
          :paths             => @paths,
          :results_directory => results_directory
        )
      end
    end

    def compute_diffs
      @results.compute_diffs
    end

    def make_index_page
      presenter = Compatriot::ResultsPresenter.new(results_directory)
      presenter.make_index_page(@results)
    end

    def create_results_directory
      FileUtils.mkdir_p(results_directory)
    end

    def results_directory
      return @results_directory if @results_directory
      timestamp = @clock.now.strftime("%Y-%m-%d-%H-%M-%S")
      File.join("tmp", "results", timestamp)
    end
  end
end