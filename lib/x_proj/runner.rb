require "fileutils"

module XProj
  class Runner
    def self.start(app, paths, clock = DateTime)
      runner = new(app, paths, clock)
      runner.take_screenshots
      runner.make_index_page
      runner
    end

    BROWSERS = ["firefox", "chrome"]

    attr_reader :app, :results

    def initialize(app, paths, clock)
      @app   = app
      @paths = paths
      @clock = clock
    end

    def take_screenshots
      @results = {}
      BROWSERS.each do |b|
        browser = XProj::Browser.new(b)
        @results[b] = browser.take_screenshots(
          :app => @app,
          :paths => @paths,
          :results_directory => results_directory
        )
      end
    end

    def results_directory
      return @results_directory if @results_directory
      timestamp = @clock.now.strftime("%Y-%m-%d-%H-%M-%S")
      directory_name = "tmp/results/#{timestamp}"
      FileUtils.mkdir_p(directory_name)
      @results_directory = directory_name
    end

    def make_index_page
      presenter = XProj::ResultsPresenter.new(results_directory)
      presenter.make_index_page(@results)
    end
  end
end