require "fileutils"

module XProj
  class Runner
    def self.start(app, clock = DateTime)
      runner = new(app, clock)
      runner.take_screenshots
      runner.make_index_page
    end

    BROWSERS = ["firefox", "chrome"]

    attr_reader :app

    def initialize(app, clock)
      @app   = app
      @clock = clock
    end

    def take_screenshots
      BROWSERS.each do |b|
        browser = XProj::Browser.new(b, @app, results_directory)
        browser.start
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
      index_page_file = File.join(results_directory, "index.html")
      html = "<html>
                <head>
                  <title>Cross browser test results</title>
                  <style type='text/css'>
                    table, tr, th, td {
                      border: 1px solid #aaa;
                    }
                    img {
                      width: 300px;
                    }
                  </style>
                <head>
                <body>
                  <h1>Results</h1>
                  <table>
                    <tr>
                      <th>Filename</th>"

      BROWSERS.each do |b|
        html << "<th>#{b}</th>"
      end

      html << "</tr>"

      screenshots = Dir.entries(File.join(results_directory, BROWSERS.first))

      screenshots = screenshots - [".", ".."]

      screenshots.each do |screenshot|
        html << "<tr><td>#{screenshot}</td>"
        html << "<td><img src='#{BROWSERS.first}/#{screenshot}' /></td>"
        (BROWSERS - [BROWSERS.first]).each do |browser|
          html << "<td><img src='#{browser}/#{screenshot}' /></td>"
        end
        html << "</tr>"
      end

      html << "</table></body></html>"
      File.open(index_page_file, 'w') {|f| f.write(html) }
    end
  end
end