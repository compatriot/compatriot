require 'erb'

module Compatriot
  class ResultsPresenter
    def initialize(results_directory)
      @results_directory = results_directory
    end

    def make_index_page(results)
      index_page_file = File.join(@results_directory, "index.html")

      b = binding
      browsers = results.browsers
      paths = results.paths

      html = ERB.new <<-EOF
        <html>
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
          </head>
          <body>
            <h1>Results</h1>
            <table>
              <tr>
                <th>Path</th>
                <% browsers.each do |browser| %>
                  <th><%= browser %></th>
                <% end %>
                <th>Diff</th>
              </tr>
              <% paths.each do |path| %>
                <tr>
                  <td>
                    <%= path %>
                  </td>
                  <% browsers.each do |browser| %>
                    <td>
                      <img src="<%= browser %>/<%= results.screenshot_for(browser, path) %>" />
                    </td>
                  <% end %>
                  <td>
                    <img src="<%= results.diff_for(path) %>" />
                  </td>
                </tr>
              <% end %>
            </table>
          </body>
        </html>
      EOF

      File.open(index_page_file, 'w') {|f| f.write(html.result(b)) }
    end
  end
end