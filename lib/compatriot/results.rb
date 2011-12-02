module Compatriot
  class Results
    def initialize
      @data = {}
    end

    def take_screenshots(params)
      @results_directory = params[:results_directory]
      @app = params[:app]
      @paths = params[:paths]

      @browser = Compatriot::Browser.new(params[:browser], @results_directory)
      @browser.initialize_capybara(@app)

      @data[params[:browser]] = @browser.take_screenshots(@paths)
    end

    def compute_diffs
      paths.each do |path|
        Compatriot::ImageDiffer.diff(
          browsers.map{|b| File.join(@results_directory, b, screenshot_for(b, path))}
        )
      end
    end

    def browsers
      @data.keys
    end

    def paths
      @data[browsers.first].keys
    end

    def screenshot_for(browser, path)
      @data[browser][path]
    end
  end
end