require "fileutils"

module XProj
  class Runner
    BROWSERS = ["firefox", "chrome"]

    def initialize(app, clock = DateTime)
      @app   = app
      @clock = clock
    end

    def start
      results_directory = make_results_directory
      BROWSERS.each do |b|
        browser = XProj::Browser.new(b, @app, results_directory)
        browser.start
      end
    end

    private

    def make_results_directory
      timestamp = @clock.now.strftime("%Y-%m-%d-%H-%M-%S")
      directory_name = "tmp/results/#{timestamp}"
      FileUtils.mkdir_p(directory_name)
      directory_name
    end
  end
end