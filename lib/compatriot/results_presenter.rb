require 'erb'

module Compatriot
  class ResultsPresenter
    def initialize(results_directory)
      @results_directory = results_directory
    end

    def make_index_page(params = {})
      index_page_file = File.join(@results_directory, "index.html")

      b = binding
      paths = params[:paths]
      browsers = params[:browsers]
      diffs = params[:diffs]

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
                <% browsers.each do |name, browser| %>
                  <th><%= name %></th>
                <% end %>
                <th>Diff</th>
              </tr>
              <% paths.each do |path| %>
                <tr>
                  <td>
                    <%= path %>
                  </td>
                  <% browsers.each do |name, browser| %>
                    <td>
                      <img src="<%= name %>/<%= browser.screenshot_for(path) %>" />
                    </td>
                  <% end %>
                  <td>
                    <img src="<%= diffs[path] %>" />
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