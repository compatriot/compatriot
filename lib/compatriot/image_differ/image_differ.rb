require_relative 'color_differ'

module Compatriot
  class ImageDiffer

    def initialize(params = {})
      @paths    = params[:paths]
      @browsers = params[:browsers]
      @strategy = params[:strategy] || Compatriot::ColorDiffer
      @results_directory = params[:results_directory]
      @diffs    = {}

      create_diffs_path
    end

    def diff_for(path)
      @diffs[path]
    end

    def compute!
      @paths.map do |path|
        images_to_diff = @browsers.map { |b| b.absolute_screenshot_for(path) }
        @diffs[path] = diff(images_to_diff)
      end
    end

    def diff(results)
      @strategy.diff(results.first, results.last)
    end

    def diffs_path
      File.join(@results_directory, "diffs")
    end

    private

    def create_diffs_path
      FileUtils.mkdir_p(diffs_path)
    end
  end
end
