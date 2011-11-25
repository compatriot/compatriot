require "fileutils"

module XProj
  class Runner
    BROWSERS = ["firefox", "chrome"]

    def initialize(clock = DateTime)
      @clock = clock
    end

    def start
      make_results_directory
    end

    private

    def make_results_directory
      timestamp = @clock.now.strftime("%Y-%m-%d-%H-%M-%S")
      FileUtils.mkdir_p("tmp/results/#{timestamp}")
      BROWSERS.each do |b|
        FileUtils.mkdir_p("tmp/results/#{timestamp}/#{b}")
      end
    end
  end
end